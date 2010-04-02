From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Fri, 2 Apr 2010 21:23:28 GMT
Message-ID: <201004022123.o32LNSjT010769@demeter.kernel.org>
References: <bug-14830-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45216 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab0DBVXa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Apr 2010 17:23:30 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o32LNTOR010773
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 2 Apr 2010 21:23:29 GMT
In-Reply-To: <bug-14830-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #23 from Eric Sandeen <sandeen@redhat.com>  2010-04-02 16:41:39 ---
The patch in comment #18 is still not upstream.  Jan, what's the status of
that?

Michael, I did discover one issue upstream related to fsync, see:

http://marc.info/?l=linux-ext4&m=126987658403214&w=2

This was very inefficient scanning of large files for sync.  However, for
sys_sync, I didn't see the problem because the loop was limited in that case,
so it may not be related.

(In reply to comment #3)
> >This problem prevents production use of systems using this kernel.
> 
> >evokes a question: Do you have a kernel which behaved better for you? Which
> >one?
> 
> Yes.  RHEL5.4 does not show this problem.  It is the production
> system that works in this environment.

RHEL5.4 on ext3 or ext4?

> The response above is disappointing.  Is sync response of 20 minutes,
> including several task timeouts to be considered "normal?"

Probably not, but it really depends.  If you have a system with massive amounts
of memory, and a slow path to the disk, then sure, if you have to flush many
many gigabytes it will be slow.  But that's extreme, and I don't think you're
in that case.  You do have a 12G box though, so that's potentially a lot of
memory to flush.  OTOH your storage should probably be reasonably fast.

It does seem like something else is going on here.

(In reply to comment #22)
> I tried another test with 2.6.32.10-90.fc12.x86_64.  I did
> not expect an improvement.  But, the results were actually
> a lot worse.  After starting an rsync  which transferred a
> few 100GB through NFS, I started a sync using time sync.
> This caused a number of the usual 2 minute timeout messages.  But, also
> it did not close until about 20 minutes after the rsync had
> completed.  All together  it ran for several hours. By the
> way it was not possible to kill the sync using kill -9.
> 
> This is clearly hopeless.

Hm, don't give up quite yet ;)

Can you describe this test a little more explicitly; which box was the nfs
server vs. client, which boxes were the rsync servers/clients, which box ran
sync?  I just don't want to make wrong assumptions in trying to recreate this.

> Will anything be done about this in 2.6.33 for fc13?

we still have to get to the bottom of the problem before we can talk about
fixes, I'm afraid.

> Will the fact that Google is going with ext4 possibly help?

I don't think so.

One thing that may be interesting is to run blktrace (or use seekwatcher to do
that for you) during the sync call that is stalling out, to get an idea of what
is happening at the block layer and when.

--- Comment #24 from Eric Sandeen <sandeen@redhat.com>  2010-04-02 21:23:21 ---
For what it's worth, assuming I have replicated the behavior properly, the
long-running sync doesn't seem unique to ext4 at all.

I can replicate it by running a script which creates 4G files in sequence,
putting it in the background, sleeping for a while, and typing "sync" - which
never returns.

I see the same behavior on ext4 as well as xfs and ext3.

I applied Jan's patch from comment #18, and the behavior is unchanged.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
