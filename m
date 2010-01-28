From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Thu, 28 Jan 2010 09:18:27 GMT
Message-ID: <201001280918.o0S9IRBp013959@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44024 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab0A1JS1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jan 2010 04:18:27 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o0S9IRI9013960
	for <linux-ext4@vger.kernel.org>; Thu, 28 Jan 2010 09:18:27 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #12 from Theodore Tso <tytso@mit.edu>  2010-01-28 09:18:21 ---
On Wed, Jan 27, 2010 at 02:06:25PM +0100, Andre Noll wrote:
> On 11:19, bugzilla-daemon@bugzilla.kernel.org wrote:
> > After kill -9 of the sync run it took about 20 minutes before 
> > it died.
> 
> I was seeing similar behaviour on one of our servers, and changing
> the io scheduler to noop fixed things for me. So it seems to be an
> issue with cfq which is somehow triggered by ext4 but not by ext3.
> 
> To change the IO scheduler, just execute
> 
> 	echo noop > /sys/block/sda/queue/scheduler
> 
> (replace sda if necessary).

Andre or Michael.  If switching away from cfq helps, that's
definitely... interesting.  Given that cfq is the default scheduler, I
definitely want to understand what might be going on here.  Are either
if you able to run blktrace so we can get a sense of what is going on
under the cfq and deadline/noop I/O schedulers?

And in both of your cases, were you using a new file system freshly
created using mke2fs -t ext4, or was this a ext2/ext3 filesystem that
was converted for use under ext4?

Thanks,

                    - Ted

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.