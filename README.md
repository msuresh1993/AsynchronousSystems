AsynchronousSystems - Assignment 2
Name: Muthukumar Suresh

RUNNING INSTRUCTIONS : run the run command
                       After all the processing is done:
                       3 graphs are generated -- these are the graphs for performance Vs Number of Requests
                       Close these graphs
                       the progam starts running again
                       3 more graphs are generated -- these are the graphs for performance Vs Number of Processes
                       close these graphs (necessary step)
                       The program should terminate
                       Open output.txt and navigate from there for correctness testing

Algorithms Implemented: La Mutex (Lamport Mutex)
                        Ra Mutex ( Ricart- Agarwala Mutex)
                        Ra Token ( Ricart Agarwala Token)

Run command: python -m da main.da 10 30 2 5 2
             where arg1 is the number of processes
             where arg2 is the number of total reqests
             where arg3 is the number of runs of performance testing
             where arg4 is the number of variations of parameters
             where arg5 is the number of reps

       You need to install numpy and matplotlib which is compatible with python3.4 to run this file.

Basic implementation Idea: A driver process is the main incharge for running all the algorithms.
                           All algorithms send messages back to the driver for logging and other tasks related to this assignment


                           Correctness Testing:
                           The project tests the performance using 3 criterias: liveness, safety and fairness
                           The output of the performance testing is in output.txt ( note: you have to close the graph windows to generate the content of the file)

                           To test liveness:
                           We just see that every process and every request is eventually served. Each process sends the number of requests and the number of times it
                           has been serviced to the driver process

                           To test safety:
                           Here, we test whether each process executes in the critical section in isolation . (EXTRA CREDIT WORK THAT IS GIVEN BELOW WAD DISCOVERED DURING
                           THIS PHASE !!) Whenever a process enters the critical section, it sends a message to the driver and similarly when it exits the CS it sends a
                           message to the driver. We then see that no 2 processes have any over lapping timeperiods. We analyze these messages to find this out.

                           To test fairness:
                           We try to see that those processes that requested the resource ( by logical timestamp) first are served first
                           We again send the details of when the request was made and in the critical section we send a message to the driver
                           The driver then checks the timestamp and the logical clock value and checks whether the right logical ordering is being followed.



                           Performance Testing:
                           We measure 3 criterias:
                           Response Time: the time taken from when the request message is sent to when the process enters critical section

                           Turnaround Time: the time taken from the request to the completion of the task

                           Message Complexity: the number of messages that are exchanged by the processes.




EXTRA CREDIT WORK:

I have used the 3 algorithm implementations in the distalgo git repo. i.e, examples/lamutex/spec.da examples/ramutex/spec.da examples/ratoken/spec.da

As mentioned in the below mail, there are implementation mistakes in ramutex/spec.da which are highlighted below:

On Fri, Sep 18, 2015 at 7:49 PM, Annie Liu <liu@cs.stonybrook.edu> wrote:

    hi, great to hear these, and thanks for letting me know! my concern about those programs was the key reason that they are not included in the zipped distribution file.  it was partly the reason for this assignment too.

    pls report those in your A2 readme file, result description, and if you can, try to fix too and get extra credit.  annie

    On Fri, Sep 18, 2015 at 7:11 PM, Muthukumar Suresh <muthukumar.suresh@stonybrook.edu> wrote:

        Hello professor,
        I was doing some correctness testing for examples/ramutex/spec.da and i found out that the code does not provide mutual exclusion.

        Firstly,
        def receive(msg=('request', c, p)):
                if each(received(('request', _c, self.id)), has=((c, p) < (ownc, self.id))):
                    send(('ack', logical_clock(), self.id), to=p)

        if you look at the if condition, why would there be a received from itself at clock time c, when a process never sends itself a request. since the message queue never has a message from itself, the condition is always satisfied.

        Also, in the same code,
        await(each(p in s,
                           has=some(received(('ack', c, p)), has=(c > ownc))))

        should  it not be (received(('ack', c, _p))?

        The code seems to work fine because ack is always sent and it looks like all processes are maintaining mutual exclusion..


        Regards,
        Muthukumar Suresh



To fix this problem, I have modified the receive(msg=('request', c, p)):

def receive(msg=('request', c, p)):
        if self.last == None or (c, p) < self.last:
            send(('ack', logical_clock(), self.id), to=p)

Where self.last is a tuple (current_clock_value, process_id). By making sure that self.last has the logical value of the last request or None if it is not requesting.
We can ensure that mutual exclusion is performed properly. By making the changes, safety property is no longer violated and the ra mutex performs properly.

Note: This was a quick-fix solution which I could be assured would work. I think we can write a more optimized version( without self.last) by tweaking certain parts of the existing ramutex
code, which I will take up after the deadline.
