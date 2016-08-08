From: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwin@etorok.net>
Subject: Re: 4.7.0-rc7 ext4 error in dx_probe
Date: Tue, 9 Aug 2016 00:13:01 +0300
Message-ID: <0bd292e7-818c-b708-4591-c7feec88f072@etorok.net>
References: <20160718141723.GA8809@sig21.net>
 <7849bcd2-142d-0a12-0a04-7d0c3b6d788f@etorok.net>
 <20160805103544.kbt7znbzypvi5ofx@sig21.net>
 <20160805170228.GA19960@birch.djwong.org>
 <20160805181136.mcjnnvuo5m6kpxzb@sig21.net>
 <20160805191548.GD19960@birch.djwong.org> <20160808035634.GA16193@thunk.org>
 <20160808062810.GC8590@birch.djwong.org> <20160808160818.GA9515@thunk.org>
 <20160808165546.GA11291@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Johannes Stezenbach <js@sig21.net>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160808165546.GA11291@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2016-08-08 19:55, Darrick J. Wong wrote:
> On Mon, Aug 08, 2016 at 12:08:18PM -0400, Theodore Ts'o wrote:
>> On Sun, Aug 07, 2016 at 11:28:10PM -0700, Darrick J. Wong wrote:
>>>
>>> I have one lingering concern -- is it a bug that two processes could be
>>> computing the checksum of a buffer simultaneously?  I would have thought ext4
>>> would serialize that kind of buffer_head access...
>>
>> Do we know how this is happening?  We've always depended on the VFS to
>> provide this exclusion.  The only way we should be modifying the
>> buffer_head at the same time if two CPU's are trying to modify the
>> directory at the same time, and that should _never_ be happening, even
>> with the new directory parallism code, unless the file system has
>> given permission and intends to do its own fine-grained locking.
> 
> It's a combination of two things, I think.  The first is that the
> checksum calculation routine (temporarily) set the checksum field to
> zero during the computation, which of course is a no-no.  The patch
> fixes that problem and should go in.

Thanks a lot for the patch.
I wrote a small testcase (see below) that triggers the problem quite soon on my box with kernel 4.7.0, and seems to have survived so far with kernel 4.7.0+patch.
When it failed it printed something like "readdir: Bad message".

The drop caches part is quite important for triggering the bug, and might explain why this bug was hard to reproduce: IIUC this race condition can happen only
if 2+ threads/processes try to access the same directory, and the directory's inode is not in the cache (i.e. was never cached, or got kicked out of the cache).


/*
 $ gcc trigger.c -o trigger -pthread
 $ ./trigger
*/

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>
#include <unistd.h>
#include <fcntl.h>

#define FILES 100000
#define THREADS 16
#define LOOPS 1000

static void die(const char *msg)
{
	perror(msg);
	exit(EXIT_FAILURE);
}

static void* list(void* arg)
{
	for(int i=0;i<LOOPS;i++) {
		DIR *d = opendir(".");
		if (!d) {
			die("opendir");
		}
		errno = 0;
		while(readdir(d)) {}
		if (errno) {
			die("readdir");
		}
		closedir(d);
		FILE *f = fopen("/proc/sys/vm/drop_caches", "w");
		if (f) {
			fputs("3", f);
			fclose(f);
		}
	}
	return NULL;
}

int main()
{
	pthread_t t[THREADS];

	if(mkdir("ext4test", 0755) < 0 && errno != EEXIST)
		die("mkdir");
	if(chdir("ext4test") < 0)
		die("chdir");
	for (unsigned i=0;i < FILES;i++) {
		char name[16];
		snprintf(name, sizeof(name), "%d", i); 
		int fd = open(name, O_WRONLY|O_CREAT, 0600);
		if (fd < 0)
			die("open");
		close(fd);
	}
	for (unsigned i=0;i < sizeof(t)/sizeof(t[0]); i++) {
		pthread_create(&t[i], NULL,list, NULL);
	}
	for (unsigned i=0;i < sizeof(t)/sizeof(t[0]); i++) {
		pthread_join(t[i], NULL);
	}
	return 0;
}



-- 
Edwin Török | Co-founder and Lead Developer

Skylable open-source object storage: reliable, fast, secure
http://www.skylable.com
