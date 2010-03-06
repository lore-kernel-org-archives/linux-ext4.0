From: Paul Chavent <paul.chavent@fnac.net>
Subject: Constant access (write) time.
Date: Sat, 06 Mar 2010 23:02:53 +0100
Message-ID: <4B92D10D.8070805@fnac.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020504000300030607030505"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:34790 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab0CFV6V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Mar 2010 16:58:21 -0500
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 058569400AD
	for <linux-ext4@vger.kernel.org>; Sat,  6 Mar 2010 22:58:15 +0100 (CET)
Received: from [192.168.2.99] (laf31-5-82-235-130-199.fbx.proxad.net [82.235.130.199])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 9507F940101
	for <linux-ext4@vger.kernel.org>; Sat,  6 Mar 2010 22:58:12 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020504000300030607030505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello.

I'm writing a real-time application that have to stream pictures to a SSD.

The pictures are 640x480x1 pnm that are stored in one tar file. I have one picture every 100ms.

I decided to code a "write" thread that open a file on an ext4 filesystem created with :
# mke2fs -t ext4 -L DATA -O large_file,^has_journal,extent -v

It is mounted with :
# mount -t ext4 /dev/sda3 /var/data/

My file descriptor is open with these flags :
O_WRONLY | O_CREAT | O_TRUNC | O_SYNC | O_DIRECT

I use a noop io scheduler.

The problem is that the access (write) time (from a userspace point of view) is not constant. I join you a piece of code that reproduce the problem.

This leads me to ask the following questions : the solution to this problem is

(1) the kernel make such a job that the write time seems constant from a userspace point of view

(2) the userspace thread haven't a constant execution time but is bounded to a maximum

(3) the userspace thread have a constant execution time but use an other userspace thread by calling aio_write


In all case, the job (some block allocation i guess) have to be done. But i suppose that if it is done anticipatory by the kernel it can be preemted by realtime task and it is better.

In the third solution we can preempt the aio thread, but the allocation isn't anticipated.


So if you could give me your point of view...


Thank you for your advices.


Paul.


--------------020504000300030607030505
Content-Type: text/plain;
 name="main.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="main.c"

/* gcc -Wall -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -o main main.c -lrt */

/* open */
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

/* write,close,pathconf */
#include <unistd.h>

/* posix_memalign */
#include <stdlib.h>

/* perror */
#include <stdio.h>

/* signal */
#include <signal.h>

/* clock_* */
#include <time.h>

/* sched_setscheduler */
#include <sched.h>

/* memset */
#include <string.h>

/* mlockall */
#include <sys/mman.h> // Needed for ()

/* getrusage */
#include <sys/time.h>
#include <sys/resource.h>
   
/* iob */
#include <sys/io.h>


#define PP_DATA 0x378

static volatile int test_is_running = 1;

void sig_handler(int sig_num)
{
  test_is_running = 0;
}

int main(int argc, char **argv)
{
  /*
   * I stream 640x480x1 pnm images (307215 bytes each) to a tar file.
   * The write buffer is multiple of 512.
   * So 307712 bytes.
   */
  const int buffer_size = 307712;
  /*
   * Alignement for direct io
   */
  int buffer_alignment;
  /*
   * The buffer will be allocated dynamicaly for alignement
   */
  void *buffer;

  int fd;

  /* 
   * Set the scheduler
   */
  struct sched_param param;

  /*
   * Monitoring variable
   */
  unsigned long long sample = 0;
  struct timespec start_time;
  struct timespec stop_time;
  unsigned long long diff_cur;
  unsigned long long diff_min;
  unsigned long long diff_max;
  unsigned long long diff_avg;
  struct timespec ts;
  unsigned long long period_ns = 200000000;
  struct rusage usage_before;
  struct rusage usage_after;

  /* handle ctrl-c */
  struct sigaction sigact;
  sigact.sa_handler= sig_handler;
  sigact.sa_flags = SA_RESETHAND;
  sigaction(SIGINT, &sigact, NULL);

  /* for pp monitoring */
  ioperm(PP_DATA, 1, 1);

  /* declare ourself as a real time task */
  param.sched_priority = 49;
  if(sched_setscheduler(0, SCHED_FIFO, &param) == -1) 
    {
      perror("sched_setscheduler failed");
      return EXIT_FAILURE;
    }

  /* lock all current and future pages from preventing of being paged */
  if(mlockall(MCL_CURRENT | MCL_FUTURE ))
    {
      perror("mlockall failed");
      return EXIT_FAILURE;
    }
     
  /* open */
  fd = open("test.log", O_WRONLY | O_CREAT | O_TRUNC | O_SYNC | O_DIRECT, 0644);
  if(fd < 0)
    {
      perror("open failed");
      return EXIT_FAILURE;
    }
 
  /* compute alignement constraints for direct io */
  buffer_alignment = pathconf("test.log", _PC_REC_XFER_ALIGN);
  if(buffer_alignment < 0)
    {
      perror("pathconf failed");
      return EXIT_FAILURE;
    }

  /* alloc aligned buffer */
  if(posix_memalign((void **)&buffer, buffer_alignment, buffer_size))
    {
      perror("posix_memalign failed");
      return EXIT_FAILURE;
    }
     
  memset(buffer, 0, buffer_size);
  
  fprintf(stderr, "%*s%*s\n", 16, "file size", 16, "duration");

  getrusage(RUSAGE_SELF, &usage_before);

  clock_gettime(CLOCK_MONOTONIC, &ts);

  while(test_is_running)
    {
      int nb_write;

      outb((inb(PP_DATA) | (0x0001)), PP_DATA);

      clock_gettime(CLOCK_MONOTONIC, &start_time);

      nb_write = write(fd, buffer, buffer_size);
 
      clock_gettime(CLOCK_MONOTONIC, &stop_time);

      outb((inb(PP_DATA) & ~(0x0001)), PP_DATA);
 
      /* error handling */
      if(nb_write != buffer_size)
        {
          perror("write failed");
          return EXIT_FAILURE;
        }

      /* compute stats */
      if(stop_time.tv_nsec < start_time.tv_nsec)
        {
          stop_time.tv_sec--;
          stop_time.tv_nsec+=1000000000;
        } 
    
      diff_cur = (stop_time.tv_sec - start_time.tv_sec) * 1000000000ULL + (stop_time.tv_nsec - start_time.tv_nsec);

      if(sample == 0)
        {
          diff_min = diff_cur;
          diff_max = diff_cur;
          diff_avg = diff_cur;
        }
      else
        {
          if(diff_cur < diff_min)
            {
              diff_min = diff_cur;
            }
          if(diff_max < diff_cur)
            {
              diff_max = diff_cur;
            }
          if(diff_cur < diff_avg)
            {
              diff_avg = diff_avg - (diff_avg - diff_cur) / sample;
            }
          else
            {
              diff_avg = diff_avg + (diff_cur - diff_avg) / sample;
            }
        }
      sample++;

      /* print suspect write */
      if((2 * diff_avg) < diff_cur)
        {
          struct stat buf;
          fstat(fd, &buf);
          fprintf(stderr, "%*llu%*llu\n", 16, buf.st_size, 16, diff_cur);
        }

      /* sleep */
      ts.tv_nsec += period_ns;
      while(ts.tv_nsec >= 1000000000)
        {
          ts.tv_nsec -= 1000000000;
          ts.tv_sec++;
        }

      clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL);
    }

  getrusage(RUSAGE_SELF, &usage_after);

  close(fd);

  fprintf(stderr, "\n");
  fprintf(stderr, "diff min : %llu\n", diff_min);
  fprintf(stderr, "diff moy : %llu\n", diff_avg);
  fprintf(stderr, "diff max : %llu\n", diff_max);
  fprintf(stderr, "%llu iterations\n", sample);
  printf("major pagefaults : %ld\nminor pagefaults : %ld\n", usage_after.ru_majflt - usage_before.ru_majflt, usage_after.ru_minflt - usage_before.ru_minflt);

  return EXIT_SUCCESS;
}

--------------020504000300030607030505--
