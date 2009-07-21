From: Xiang Wang <xiangw@google.com>
Subject: Re: Using O_DIRECT in ext4
Date: Tue, 21 Jul 2009 13:46:24 -0700
Message-ID: <d5ca277e0907211346u65282484ye6ee5da38c1b9d71@mail.gmail.com>
References: <d5ca277e0907201841i18b83bb6uea757e83d177bc9b@mail.gmail.com>
	 <4A6538DB.5050202@redhat.com>
	 <6601abe90907210745k3730f74dq62f1fe6539722b4d@mail.gmail.com>
	 <4A65EEF3.9090507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:47797 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbZGUUq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jul 2009 16:46:29 -0400
Received: from zps38.corp.google.com (zps38.corp.google.com [172.25.146.38])
	by smtp-out.google.com with ESMTP id n6LKkSsK014963
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2009 13:46:28 -0700
Received: from ewy23 (ewy23.prod.google.com [10.241.103.23])
	by zps38.corp.google.com with ESMTP id n6LKkPCO005580
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2009 13:46:26 -0700
Received: by ewy23 with SMTP id 23so3429970ewy.19
        for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2009 13:46:25 -0700 (PDT)
In-Reply-To: <4A65EEF3.9090507@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 21, 2009 at 9:38 AM, Eric Sandeen<sandeen@redhat.com> wrote=
:
> Curt Wohlgemuth wrote:
>> On Mon, Jul 20, 2009 at 8:41 PM, Eric Sandeen<sandeen@redhat.com> wr=
ote:
>>> Xiang Wang wrote:
>
>>>> For comparison, I did the same experiment on an ext2 partition,
>>>> resulting in each file having only 1 extent.
>>> Interestinng, not sure I would have expected that.
>>
>> Same with us; we're looking into more variables to understand it.
>
> To be more clear, I would not have expected ext2 to deal well with it
> either, is more what I meant ;) =A0I'm not terribly surprised that ex=
t4
> gets fragmented.
>
> For the numbers posted, how big were the files (how many 1m chunks we=
re
> written?)
>
> Just FWIW; I did something like:
>
> # for I in `seq 1 16`; do dd if=3D/dev/zero of=3Dtestfile$I bs=3D1M c=
ount=3D16
> oflag=3Ddirect & done
>
> on a rhel5.4 beta kernel and got:
>
> ~5 extents per file on ext4 (per filefrag output)
> between 41 and 234 extents on ext2.
> ~6 extents per file on ext3.
> ~16 extents per file on xfs
>

I repeated this test(bs=3D1M count=3D16) by tuning some parameters in m=
y
test program. And I got the following results(per filefrag output):
ext4:
5 extents per file

ext2:
file0: 5 extents found, perfection would be 1 extent
file1: 5 extents found, perfection would be 1 extent
file2: 6 extents found, perfection would be 1 extent
file3: 4 extents found, perfection would be 1 extent
file4: 4 extents found, perfection would be 1 extent
file5: 6 extents found, perfection would be 1 extent
file6: 4 extents found, perfection would be 1 extent
file7: 5 extents found, perfection would be 1 extent
file8: 6 extents found, perfection would be 1 extent
file9: 4 extents found, perfection would be 1 extent
file10: 5 extents found, perfection would be 1 extent
file11: 6 extents found, perfection would be 1 extent
file12: 6 extents found, perfection would be 1 extent
file13: 8 extents found, perfection would be 1 extent
file14: 4 extents found, perfection would be 1 extent
file15: 7 extents found, perfection would be 1 extent

The results on ext4 look comparable to yours while the results on ext2
look very different.
I am attaching the test program I use in case you want to try it. It
is at the end of the message.
I invoked it like: ./mt_writes 16 1 to have 16 threads writing using O_=
DIRECT.

> if I created a subdir for each file:
>
> # for I in `seq 1 16`; do mkdir dir$I; dd if=3D/dev/zero
> of=3Ddir$I/testfile$I bs=3D1M count=3D16 oflag=3Ddirect & done
>
> ~5 extents per file on ext4
> 1 or 2 extents per file on ext2
> 1 or 2 extents per file on ext3
> ~16 extents per file on xfs.
>
> -Eric
>

=3D=3D=3D=3D=3D=3D
/*
 * mt_write.c -- multiple threads extending files concurrently.
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <pthread.h>
#include <sys/stat.h>
#include <fcntl.h>

#define _XOPEN_SOURCE 600
#define O_DIRECT        00040000        /* direct disk access hint */

#define MAX_THREAD 1000
#define BUFSIZE 1048576
#define COUNT 16

typedef struct {
        int id;
        int odirect;
} parm;

void *expand(void *arg)
{
        char *buf;
        char fname[16];
        int fd;
        int i, count;
        parm *p =3D (parm *)arg;

        // O_DIRECT needs to work with aligned memory
        if (posix_memalign((void *) &buf, 512, BUFSIZE) !=3D 0) {
                fprintf(stderr, "cannot allocate aligned mem!\n");
                return NULL;
        }

        sprintf(fname, "file%d", p->id);
        if (p->odirect)
                fd =3D open(fname, O_RDWR|O_CREAT|O_APPEND|O_DIRECT);
        else
                fd =3D open(fname, O_RDWR|O_CREAT|O_APPEND);

        if (fd =3D=3D -1) {
                fprintf(stderr, "Open %s failed!\n", fname);
                return NULL;
        }

        for(i =3D 0; i < COUNT; i++) {
                count =3D write(fd, buf, BUFSIZE);
                if (count =3D=3D -1) {
                        fprintf(stderr, "Only able to finish %d blocks
of data\n", i);
                        return NULL;
                }
        }

        if (!p->odirect) {
                fsync(fd);
        }
        printf("Done with writing %d blocks of data\n", COUNT);
        close(fd);
        free(buf);
        return NULL;
}

int main(int argc, char* argv[]) {
        int n,i, odirect;
        pthread_t *threads;
        pthread_attr_t pthread_custom_attr;
        parm *p;

        if (argc !=3D 3)
        {
                printf ("Usage: %s <# of threads> <O_DIRECT? 1:0>\n",ar=
gv[0]);
                exit(1);
        }

        n=3Datoi(argv[1]);
        odirect =3D atoi(argv[2]);

        if ((n < 1) || (n > MAX_THREAD))
        {
                printf ("The # of thread should between 1 and
%d.\n",MAX_THREAD);
                exit(1);
        }

        threads=3D(pthread_t *)malloc(n*sizeof(*threads));
        pthread_attr_init(&pthread_custom_attr);

        p=3D(parm *)malloc(sizeof(parm)*n);
        /* Start up thread */
        for (i =3D 0; i < n; i++)
        {
                p[i].id =3D i;
                p[i].odirect =3D odirect;
                pthread_create(&threads[i], &pthread_custom_attr,
expand, (void *)(p+i));
        }

        /* Synchronize the completion of each thread. */

        for (i=3D0; i<n; i++)
        {
                pthread_join(threads[i],NULL);
        }
        free(p);
        return 0;
}
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
