From: Ryoichi KATO <Ryoichi.Kato@jp.sony.com>
Subject: Re: e2fsck bogus error report on orphan-list
Date: Fri, 20 Jul 2007 18:45:35 +0900
Message-ID: <87tzrz1k8w.wl%ryoichi@me.sony.co.jp>
References: <873azkl7x4.wl%ryoichi@me.sony.co.jp>
	<20070719165510.GB14815@thunk.org>
	<87fy3krnet.wl%ryoichi@me.sony.co.jp>
	<20070720041052.GD26752@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	tim.bird@am.sony.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from NS4.Sony.CO.JP ([137.153.0.44]:51606 "EHLO ns4.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948AbXGTJqb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jul 2007 05:46:31 -0400
In-Reply-To: <20070720041052.GD26752@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

At Fri, 20 Jul 2007 00:10:52 -0400,
Theodore Tso wrote:
> So for it to trigger it requires a very strange set of modulations of
> the time.  You need to have time be correct at the time of the mount
> (so s_mtime is sane, implying that the RTC backup battery is not
> dead), and *then* reset to the 1970's, delete some files, then be
> correct when the filesystem is unmounted (so s_wtime is sane).  That's
> pretty hard to accomplishl; and I would submit, even on embedded
> systems.  The system clock must be crazily warping back and forth
> between correct time and 1970's/insane time in order for this to be an
> issue.  

If I'm understanding correctly, once you have deleted a file in 1970,
it might stay in a filesystem for a certain period of time, like a time bomb.
Then you don't have to have the clock to jump back and forth.
I seems to me that evan a typical PCs can have the symptom,
after two reboots like this:

  1.  RTC backup run out
  2.  hardware reboot; set RTC to 1970.
  3.  mount, delete a file (in 2007)
  4.  umount
  5.  Set clock to 2007 (manually, or by NTP)
  - - - -
  6.  reboot (software reset which don't reset the RTC, or replace battery.)
  7.  e2fsck (no problem this time)
  8.  mount (in 2007)
  9.  write (in 2007)
  10. umount 
  - - - -
  11. reboot
  12. e2fsck, hit the problem.

No way to notice the real reason (RTC), if the system is a server
and only reboots once a year.

 
> >  * It is very difficult to relate RTC to the problem.
> >    No clue without digging into e2fsck source code.
> 
> Yes.  As I said, it might be a good idea to add an
> unreliable_system_time config parameter to e2fsck in the future to
> catch this case.  That would also document the issue to avoid future
> people from running into this.
And might it be also very helpful to have some hint in the e2fsck message?


> >  * -p (preen) option of e2fsck doen't fix it automatically.
> >    Though I'm not sure but, maybe it's safe to correct the
> >    problem automatically?
> 
> Yes, but this was deliberate; if there was a bug in the kernel's
> orphan handling code, I really wanted to know about it, and if it was
> just -p, most folk would never know.  (Although if there were orphan
> list handling bugs, it could cause some truncates would not be
> reliably replayed, so it might cause even **harder** to diagnose bugs.
> Life is always full of tradeoffs.)
OK, I agree.  You have at least one example of such person here :-)


Regards,
--
Ryoichi KATO <Ryoichi.Kato@jp.sony.com>
    Audio Development & Engineering Div.
    Sony Corporation Audio Business Group
    Tel +81-3-3599-3862 / Fax +81-3-3599-3859
