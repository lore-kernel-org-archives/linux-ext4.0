From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Mon, 15 Aug 2011 12:00:49 +0400
Message-ID: <4E48D231.5060807@msgid.tls.msk.ru>
References: <4E456436.8070107@msgid.tls.msk.ru> <1313251371-3672-1-git-send-email-tm@tao.ma> <4E4836A8.3080709@msgid.tls.msk.ru> <4E48390E.9050102@msgid.tls.msk.ru> <4E488625.609@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:54858 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab1HOIAx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Aug 2011 04:00:53 -0400
In-Reply-To: <4E488625.609@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

15.08.2011 06:36, Tao Ma wrote:
> On 08/15/2011 05:07 AM, Michael Tokarev wrote:
[]
>> Well, I found a way to trigger data corruption with this patch
>> applied.  I guess it's not fault of this patch, but some more
>> deep problem instead.
>>
>> The sequence is my usual copy of an oracle database from another
>> place and start it.  When oracle starts doing it's direct-I/O
>> against its redologs, we had problem which is now solved.  But
>> now I do the following: I shutdown the database, rename the current
>> redologs out of the way and copy them back into place as new files.
>> And start the database again.
>>
>> This time, oracle complains that the redologs contains garbage.
>> I can reboot the machine now, and compare old (renamed) redologs
>> with copies - they're indeed different.
>>
>> My guess is that copy is done from the pagecache - from the old
>> contents of the files, somehow ignoring the (direct) writes
>> performed by initial database open.  But that copy is somehow
>> damaged now too, since even file identification is now different.
>>
>> Is this new issue something that dioread_nolock supposed to create?
>> I mean, it isn't entirely clear what it supposed to do, it looks
>> somewhat hackish, but without it performance is quite bad.
> So could I generalize your sequence like below:
> 1. copy a large file to a new ext4 volume
> 2. do some direct i/o read/write to this file(bs=512)
> 3. rename it.
> 4. cp this back to the original file
> 5. do direct i/o read/write(bs=512) now and the file is actually corrupted.
> 
> You used to meet with problem in step 2, and my patch resolved it. Now
> you met with problems in step 5. Right?

SQL> shutdown immediate; -- shuts down the database cleanly

$ mkdir tmp
$ mv redo* tmp/
$ cp -p tmp/* .
 -- this will make redolog files to be in hot cache, not even written to disk.

SQL> startup
Database mounted.
  -- now open and read our redologs...
  -- at this point, without the patch, it hangs.
ORA-00316: log 1 of thread 1, type  in header is not log file
ORA-00312: online log 1 thread 1: '.../redo1.odf'

$ mv -f tmp/* .

SQL> alter database open;  -- this will try to open files again and read them again
Database altered.          -- and now we're fine.

This is my small(ish) testcase so far.  Only the redologs
needs to be in hot cache in order to trigger the issue.
This does direct I/O in 512byte blocks in these redo*
files.

The rename and a new directory is just to keep the pieces
of the database in the right place.

There's even more fun.  I once managed to get old content in
the copied files, but I can't repeat it.  I made a copy as
before, sync(1)ed everything, started the database - it was
ok.  Next I shut it down, and rebooted (why drop_caches does
not really work is another big question).  And now, oracle
complains that the redologs contains previous sequence number.
(to clarify: there's a sequence number in each oracle db
which is incremented each time something happens with the
database, including startup. So on startup, each file in
the database gets new (the same) sequence number).  So it
looked like even despite of oracle doing direct writes to
record new sequence number, a previously cached data gets
written to the file.

Now I'm not really sure what's going on, it is somewhat
inconsistent.  Before, it used to hang after "Database
mounted" message, when it tries to write to redologs, --
now that hang is gone.

But now I see some apparent data corruption - again, with hot
cache only - but I don't actually understand when it happens.

I'm trying to narrow it down further.

Thank you!

/mjt
