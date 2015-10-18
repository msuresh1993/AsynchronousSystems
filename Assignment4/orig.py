
import da
PatternExpr_0 = da.pat.TuplePattern([da.pat.ConstantPattern('respond'), da.pat.BoundPattern('_BoundPattern1_'), da.pat.FreePattern(None)])
PatternExpr_1 = da.pat.FreePattern('a')
PatternExpr_3 = da.pat.TuplePattern([da.pat.ConstantPattern('respond'), da.pat.BoundPattern('_BoundPattern16_'), da.pat.TuplePattern([da.pat.FreePattern('n2'), da.pat.FreePattern('v')])])
PatternExpr_5 = da.pat.TuplePattern([da.pat.ConstantPattern('respond'), da.pat.BoundPattern('_BoundPattern34_'), da.pat.TuplePattern([da.pat.FreePattern('n2'), da.pat.FreePattern(None)])])
PatternExpr_7 = da.pat.TuplePattern([da.pat.ConstantPattern('respond'), da.pat.BoundPattern('_BoundPattern52_'), da.pat.FreePattern(None)])
PatternExpr_8 = da.pat.FreePattern('a')
PatternExpr_10 = da.pat.TuplePattern([da.pat.ConstantPattern('done')])
PatternExpr_11 = da.pat.TuplePattern([da.pat.ConstantPattern('prepare'), da.pat.FreePattern('n')])
PatternExpr_12 = da.pat.FreePattern('p')
PatternExpr_13 = da.pat.TuplePattern([da.pat.ConstantPattern('respond'), da.pat.FreePattern('n2'), da.pat.FreePattern(None)])
PatternExpr_15 = da.pat.TuplePattern([da.pat.ConstantPattern('accepted'), da.pat.FreePattern('n'), da.pat.FreePattern('v')])
PatternExpr_17 = da.pat.TuplePattern([da.pat.ConstantPattern('accepted'), da.pat.FreePattern('n'), da.pat.FreePattern(None)])
PatternExpr_19 = da.pat.TuplePattern([da.pat.ConstantPattern('accept'), da.pat.FreePattern('n'), da.pat.FreePattern('v')])
PatternExpr_20 = da.pat.TuplePattern([da.pat.ConstantPattern('respond'), da.pat.FreePattern('n2'), da.pat.FreePattern(None)])
PatternExpr_22 = da.pat.TuplePattern([da.pat.ConstantPattern('done')])
PatternExpr_23 = da.pat.TuplePattern([da.pat.ConstantPattern('accepted'), da.pat.FreePattern('n'), da.pat.FreePattern('v')])
PatternExpr_25 = da.pat.TuplePattern([da.pat.ConstantPattern('accepted'), da.pat.BoundPattern('_BoundPattern149_'), da.pat.BoundPattern('_BoundPattern150_')])
PatternExpr_26 = da.pat.FreePattern('a')
import sys
from random import randint
import time

class Proposer_orig(da.DistProcess):

    def __init__(self, parent, initq, channel, props):
        super().__init__(parent, initq, channel, props)
        self._Proposer_origReceivedEvent_0 = []
        self._Proposer_origReceivedEvent_1 = []
        self._Proposer_origReceivedEvent_2 = []
        self._Proposer_origReceivedEvent_3 = []
        self._events.extend([da.pat.EventPattern(da.pat.ReceivedEvent, '_Proposer_origReceivedEvent_0', PatternExpr_0, sources=[PatternExpr_1], destinations=None, timestamps=None, record_history=True, handlers=[]), da.pat.EventPattern(da.pat.ReceivedEvent, '_Proposer_origReceivedEvent_1', PatternExpr_3, sources=None, destinations=None, timestamps=None, record_history=True, handlers=[]), da.pat.EventPattern(da.pat.ReceivedEvent, '_Proposer_origReceivedEvent_2', PatternExpr_5, sources=None, destinations=None, timestamps=None, record_history=True, handlers=[]), da.pat.EventPattern(da.pat.ReceivedEvent, '_Proposer_origReceivedEvent_3', PatternExpr_7, sources=[PatternExpr_8], destinations=None, timestamps=None, record_history=True, handlers=[]), da.pat.EventPattern(da.pat.ReceivedEvent, '_Proposer_origReceivedEvent_4', PatternExpr_10, sources=None, destinations=None, timestamps=None, record_history=None, handlers=[self._Proposer_orig_handler_0])])

    def setup(self, acceptors):
        self.acceptors = acceptors
        self.n = None
        self.majority = self.acceptors
        self.count = 0

    def _da_run_internal(self):
        while True:
            self.to_consent()

    def to_consent(self):
        self.n = ((0, self.id) if (self.n == None) else ((self.n[0] + 1), self.id))
        self._send(('prepare', self.n), self.majority)
        _st_label_13 = 0
        while (_st_label_13 == 0):
            _st_label_13 += 1
            if (len({a for (_, (_, _, a), (_ConstantPattern12_, _BoundPattern13_, _)) in self._Proposer_origReceivedEvent_0 if (_ConstantPattern12_ == 'respond') if (_BoundPattern13_ == self.n)}) > (len(self.acceptors) / 2)):
                v = anyof(({v for (_, _, (_ConstantPattern28_, _BoundPattern29_, (n2, v))) in self._Proposer_origReceivedEvent_1 if (_ConstantPattern28_ == 'respond') if (_BoundPattern29_ == self.n) if (n2 == max({n2 for (_, _, (_ConstantPattern46_, _BoundPattern47_, (n2, _))) in self._Proposer_origReceivedEvent_2 if (_ConstantPattern46_ == 'respond') if (_BoundPattern47_ == self.n)}))} or {randint(1, 100)}))
                responded = {a for (_, (_, _, a), (_ConstantPattern63_, _BoundPattern64_, _)) in self._Proposer_origReceivedEvent_3 if (_ConstantPattern63_ == 'respond') if (_BoundPattern64_ == self.n)}
                self._send(('accept', self.n, v), responded)
                self.output('### chose', self.n, v)
                self.count += 1
                _st_label_13 += 1
            else:
                super()._label('_st_label_13', block=True)
                _st_label_13 -= 1

    def _Proposer_orig_handler_0(self):
        self.output('terminating')
        self.exit()
    _Proposer_orig_handler_0._labels = None
    _Proposer_orig_handler_0._notlabels = None

class Acceptor_orig(da.DistProcess):

    def __init__(self, parent, initq, channel, props):
        super().__init__(parent, initq, channel, props)
        self._Acceptor_origSentEvent_1 = []
        self._Acceptor_origSentEvent_2 = []
        self._Acceptor_origSentEvent_3 = []
        self._Acceptor_origSentEvent_5 = []
        self._events.extend([da.pat.EventPattern(da.pat.ReceivedEvent, '_Acceptor_origReceivedEvent_0', PatternExpr_11, sources=[PatternExpr_12], destinations=None, timestamps=None, record_history=None, handlers=[self._Acceptor_orig_handler_1]), da.pat.EventPattern(da.pat.SentEvent, '_Acceptor_origSentEvent_1', PatternExpr_13, sources=None, destinations=None, timestamps=None, record_history=True, handlers=[]), da.pat.EventPattern(da.pat.SentEvent, '_Acceptor_origSentEvent_2', PatternExpr_15, sources=None, destinations=None, timestamps=None, record_history=True, handlers=[]), da.pat.EventPattern(da.pat.SentEvent, '_Acceptor_origSentEvent_3', PatternExpr_17, sources=None, destinations=None, timestamps=None, record_history=True, handlers=[]), da.pat.EventPattern(da.pat.ReceivedEvent, '_Acceptor_origReceivedEvent_4', PatternExpr_19, sources=None, destinations=None, timestamps=None, record_history=None, handlers=[self._Acceptor_orig_handler_2]), da.pat.EventPattern(da.pat.SentEvent, '_Acceptor_origSentEvent_5', PatternExpr_20, sources=None, destinations=None, timestamps=None, record_history=True, handlers=[]), da.pat.EventPattern(da.pat.ReceivedEvent, '_Acceptor_origReceivedEvent_6', PatternExpr_22, sources=None, destinations=None, timestamps=None, record_history=None, handlers=[self._Acceptor_orig_handler_3])])

    def setup(self, learners):
        self.learners = learners
        pass

    def _da_run_internal(self):
        _st_label_39 = 0
        while (_st_label_39 == 0):
            _st_label_39 += 1
            if False:
                _st_label_39 += 1
            else:
                super()._label('_st_label_39', block=True)
                _st_label_39 -= 1

    def _Acceptor_orig_handler_1(self, n, p):
        n2 = None

        def UniversalOpExpr_0():
            nonlocal n2
            for (_, _, (_ConstantPattern83_, n2, _)) in self._Acceptor_origSentEvent_1:
                if (_ConstantPattern83_ == 'respond'):
                    if (not (n > n2)):
                        return False
            return True
        if UniversalOpExpr_0():
            max_prop = anyof({(n, v) for (_, _, (_ConstantPattern97_, n, v)) in self._Acceptor_origSentEvent_2 if (_ConstantPattern97_ == 'accepted') if (n == max({n for (_, _, (_ConstantPattern111_, n, _)) in self._Acceptor_origSentEvent_3 if (_ConstantPattern111_ == 'accepted')}))})
            self._send(('respond', n, max_prop), p)
    _Acceptor_orig_handler_1._labels = None
    _Acceptor_orig_handler_1._notlabels = None

    def _Acceptor_orig_handler_2(self, n, v):
        n2 = None

        def ExistentialOpExpr_1():
            nonlocal n2
            for (_, _, (_ConstantPattern129_, n2, _)) in self._Acceptor_origSentEvent_5:
                if (_ConstantPattern129_ == 'respond'):
                    if (n2 > n):
                        return True
            return False
        if (not ExistentialOpExpr_1()):
            self._send(('accepted', n, v), self.learners)
    _Acceptor_orig_handler_2._labels = None
    _Acceptor_orig_handler_2._notlabels = None

    def _Acceptor_orig_handler_3(self):
        self.output('terminating')
        self.exit()
    _Acceptor_orig_handler_3._labels = None
    _Acceptor_orig_handler_3._notlabels = None

class Learner_orig(da.DistProcess):

    def __init__(self, parent, initq, channel, props):
        super().__init__(parent, initq, channel, props)
        self._Learner_origReceivedEvent_0 = []
        self._Learner_origReceivedEvent_1 = []
        self._events.extend([da.pat.EventPattern(da.pat.ReceivedEvent, '_Learner_origReceivedEvent_0', PatternExpr_23, sources=None, destinations=None, timestamps=None, record_history=True, handlers=[]), da.pat.EventPattern(da.pat.ReceivedEvent, '_Learner_origReceivedEvent_1', PatternExpr_25, sources=[PatternExpr_26], destinations=None, timestamps=None, record_history=True, handlers=[])])

    def setup(self, acceptors):
        self.acceptors = acceptors
        pass

    def _da_run_internal(self):
        self.learn()
        self.output('terminating')

    def learn(self):
        n = v = a = None

        def ExistentialOpExpr_2():
            nonlocal n, v, a
            for (_, _, (_ConstantPattern145_, n, v)) in self._Learner_origReceivedEvent_0:
                if (_ConstantPattern145_ == 'accepted'):
                    if (len({a for (_, (_, _, a), (_ConstantPattern160_, _BoundPattern161_, _BoundPattern162_)) in self._Learner_origReceivedEvent_1 if (_ConstantPattern160_ == 'accepted') if (_BoundPattern161_ == n) if (_BoundPattern162_ == v)}) > (len(self.acceptors) / 2)):
                        return True
            return False
        _st_label_44 = 0
        while (_st_label_44 == 0):
            _st_label_44 += 1
            if ExistentialOpExpr_2():
                self.output('learned', n, v)
                _st_label_44 += 1
            else:
                super()._label('_st_label_44', block=True)
                _st_label_44 -= 1
