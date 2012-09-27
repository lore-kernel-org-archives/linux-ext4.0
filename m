From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v2 07/10] vfs: fork one kthread to update data temperature
Date: Thu, 27 Sep 2012 15:19:51 +0800
Message-ID: <CAEH94Ljjjyvj0b4Y6ktTExnCKTmC9u3r_Zb6duN4Eobkf06yXQ@mail.gmail.com>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
	<1348404995-14372-8-git-send-email-zwu.kernel@gmail.com>
	<20120927040357.GO15236@dastard>
	<CAEH94LgMXNZ_6Cs-YbhWVocO6jWb+Xq8=xgooimCFGnFbuEw5Q@mail.gmail.com>
	<20120927070117.GR15236@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	cmm@us.ibm.com, tytso@mit.edu, marco.stornelli@gmail.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51399 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab2I0HTx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2012 03:19:53 -0400
In-Reply-To: <20120927070117.GR15236@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 27, 2012 at 3:01 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Sep 27, 2012 at 02:54:22PM +0800, Zhi Yong Wu wrote:
>> On Thu, Sep 27, 2012 at 12:03 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Sun, Sep 23, 2012 at 08:56:32PM +0800, zwu.kernel@gmail.com wrote:
>> >> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> >>
>> >>   Fork and run one kernel kthread to calculate
>> >> that temperature based on some metrics kept
>> >> in custom frequency data structs, and store
>> >> the info in the hash table.
>> >
>> > No new kthreads, please. Use a per-superblock workqueue and a struct
>> > delayed_work to run periodic work on each superblock.
>> If no new kthread is created, which kthread will work on these
>> delayed_work tasks?
>
> One of the kworker threads that service the workqueue
> infrastructure.
Got it, thanks
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu
