From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Mon, 21 Jul 2014 22:35:24 -0600
Message-ID: <53CDEA0C.6060400@hp.com>
References: <1400185026-3972-1-git-send-email-jack@suse.cz> <1400185026-3972-3-git-send-email-jack@suse.cz> <537B1353.8060704@hp.com> <20140520135723.GB15177@thunk.org> <538CB83C.9080409@hp.com> <20140603085205.GA29219@quack.suse.cz> <539F4380.5090001@hp.com> <20140617092932.GB8622@quack.suse.cz> <53A117C8.3000207@hp.com> <20140618103738.GA16162@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:7778 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaGVEgt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jul 2014 00:36:49 -0400
In-Reply-To: <20140618103738.GA16162@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/18/2014 04:37 AM, Jan Kara wrote:
>   That's not true. The original test program creates one file per process:
> void run_test(char *base, int count)
> {
> ...
>        sprintf(pbuf, "%s/file-%d", base, count);
>        fd = open(pbuf, O_CREAT | O_TRUNC | O_WRONLY, 0644);
> ...
>   and forks given number of processes. Ah, maybe I see what you are getting
> at. My original test program doesn't bother with synchronizing start of the
> processes - I have manually set number of repetitions (COUNT) so that each
> process runs long enough on my machine that the differences in start time
> are negligible.  Maybe you thought these processes run sequentially (and
> maybe they really did if you had fast enough setup). So I agree
> synchronization of start using shared memory as you did it is a good thing
> and gets more reliable numbers especially for high numbers of processes
> (which I didn't really test because of my limited HW) just there's no need
> to add another level of iteration...
> 
First sorry for taking a little long to get back.

Your original main is now my new run_main() function.  The old main and new run_main() function, practically are doing the same thing, fork and immediately all the child processes as indicated by argv[1], running the original run_test() function.  By converting it to a run_main function, I'm trying to start each incarnation of the old main as closed to each other as possible, making sure I have some overlapping orphan activities on different files.  Actually I should have done the synchronization in the run_test function instead, this way both tests should be closer to each other.

>   Exactly, it's strange you saw a difference.
> 
>> I just discovered that the two different branches I used do not have the
>> same baseline.  Let me recreate the two branches and redo my test.  I'll
>> get back with you with the results.
>   OK, looking forward to the results.
> 
> 								Honza
> 

Here are the results with 3.15-rc5 baseline kernel, using your original test.  Each result is an average over ten runs, except those longer runs, marked with an '*', which is an average of only 5 runs.

On a 2 socket 16 thread machine,

            ----------------------------------
 Num files  |   40  |  100  |  400  |  1000  |
----------------------------------------------
|W/O Mutexes|118.593|178.118|595.017|1480.165|
-----------------------------------------------
|W Mutexes  |129.212|194.728|620.412|1430.908|
----------------------------------------------

On an 8 socket 160 thread machine,

            --------------------------------------------
 Num files  |   40  |  100  |   400  |  1000* |  1500* |
-------------------------------------------------------
|W/O Mutexes|387.257|644.270|1692.018|4254.766|7362.064|
-------------------------------------------------------
|W Mutexes  |328.490|557.508|1967.676|4721.060|7013.618|
--------------------------------------------------------

>From the above data, looks like without mutexes (WOM) performs better across the board on a smaller machine, except at 1000 files.  For a larger machine, I give the edge to with mutexes (WM) for smaller number of files, until around 400 to 100 something files.  Looks like with WOM starts performing better again at 1500 files.

I've noticed that your test seems to generate high volume of both add and delete orphan operations for inodes that are either already on or off the orphan chain already, favoring the WM.  I've also done some data collection to verify that.  It turns out about half of both the delete and add orphan operations do indeed fell into that category.

I did some further experiment by changing the decrement in the ftruncate() loop in the run_test() function, from 1 to be a variable configurable from the command line, as shown here,

        for (i = 0; i < COUNT; i++) {
                if (pwrite(fd, wbuf, 4096, 0) != 4096) {
                        perror("pwrite");
                        exit(1);
                }

                for (j = 4096 - ndec ; j >= 1; j -= ndec) {
                        if (ftruncate(fd, j) < 0) {
                                perror("ftruncate");
                                exit(1);
                        }
                }
        }

Here are more results with different decrement values.

On a 2 socket 16 thread machine,
with decrement of 32,
   
            --------------------------------------------------
 Num files  |  40 | 100 | 400  | 1000 | 1500 | 2000  | 2500  |
--------------------------------------------------------------
|W/O Mutexes|4.077|5.928|19.005|46.056|95.767|514.050|621.227|
--------------------------------------------------------------
|W Mutexes  |4.441|6.354|19.837|44.771|63.068| 85.997|284.084|
--------------------------------------------------------------

with decrement of 256,
   
            -----------------------------------------------------
 Num files  |  40 | 100 | 400 | 1000| 1500 | 2000 | 2500 | 3000 |
--------------------------------------------------------------
|W/O Mutexes|0.482|0.708|2.486|6.072|11.111|54.994|69.695|81.657|
-----------------------------------------------------------------
|W Mutexes  |0.540|0.823|2.449|5.650| 8.146|11.179|26.453|34.705|
-----------------------------------------------------------------

with decrement of 4095,

            -------------------------------------------------------------
 Num files  |  40 | 100 | 400 | 1000| 1500| 2000| 2500| 3000| 4000| 5000|
-------------------------------------------------------------------------
|W/O Mutexes|0.063|0.010|0.235|0.479|0.665|1.701|2.620|3.812|4.986|7.047|
-------------------------------------------------------------------------
|W Mutexes  |0.064|0.011|0.217|0.462|0.682|0.886|1.374|2.091|3.602|4.650|
-------------------------------------------------------------------------

On an 8 socket 160 thread machine,
with decrement of 32,
   
            --------------------------------------------------------
 Num files  |  40  | 100  | 400  | 1000  | 1500  |  2000  | 2500*  |
--------------------------------------------------------------------
|W/O Mutexes|15.461|21.501|54.009|131.591|219.795|2375.105|6401.232|
--------------------------------------------------------------------
|W Mutexes  |13.376|18.557|61.573|146.369|217.394| 375.293|2626.881|
--------------------------------------------------------------------

with decrement of 256,
   
            -------------------------------------------------
 Num files  |  40 | 100 | 400 | 1000 | 1500 | 2000  | 2500  |
-------------------------------------------------------------
|W/O Mutexes|1.903|2.709|7.212|16.573|26.634|260.666|745.265|
-------------------------------------------------------------
|W Mutexes  |1.643|2.319|7.429|17.641|26.059| 45.333|302.096|
-------------------------------------------------------------

with decrement of 4095,

            ---------------------------------------------
 Num files  |  40 | 100 | 400 | 1000| 1500| 2000 | 2500 |
---------------------------------------------------------
|W/O Mutexes|0.160|0.231|0.746|1.640|2.307|13.586|49.986|
---------------------------------------------------------
|W Mutexes  |0.134|0.192|0.579|1.306|1.931| 3.332|15.481|
---------------------------------------------------------

Looks like the results are similar to that of decrement of 1.  With the exception that on smaller machine, with higher decrement values, both the WM and WOM seems to performance closer to each other for small to medium number of files.  The WOM does show better scaling for higher number of files on both the small and large core count machines.

Here are also aim7 results on an 8 socket 160 threads machine, at 2000 users,

           | % of Average job per minutes of WM compared to WOM
----------------------------------------------------------------
all_tests  | +42.02%
----------------------------------------------------------------
custom     | +56.22%
----------------------------------------------------------------
dbase      |      0%
----------------------------------------------------------------
disk       |      0%
----------------------------------------------------------------
fserver    | +51.23%
----------------------------------------------------------------
new_dbase  |      0%
----------------------------------------------------------------
new_fserver|+53.83%
----------------------------------------------------------------
shared     |+44.37%
----------------------------------------------------------------

Please let me know if you have need any additional info or have any question and also if you would like a copy of the patch for testing.

Thanks,
Mak.




