From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: convert from ext3 versus fresh format
Date: Mon, 29 Nov 2010 12:29:58 -0500
Message-ID: <AANLkTi=mHZf=pofsOFsP9Y6dnvS+vHy_9De=1fz7uCiA@mail.gmail.com>
References: <1290978963.16103.1407558601@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: linux_ext4@proinbox.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50278 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab0K2RaT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 12:30:19 -0500
Received: by iwn5 with SMTP id 5so386538iwn.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 09:30:18 -0800 (PST)
In-Reply-To: <1290978963.16103.1407558601@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 28, 2010 at 4:16 PM,  <linux_ext4@proinbox.com> wrote:
> Hi list,
>
> I have a production system installed on an SSD, whose installer formats
> the target drive as ext3 automatically. I've since learned that ext4 is
> more suited for use on SSDs and am considering an upgrade to ext4.

If your only driver is SSD discard capability, then use the ext4
driver to work with your ext3 partition.  (It's backward compatible.)

Then I would recommend you use the userspace tool wiper.sh / hdparm to
do a once a week or so discard of freespace.

I maintain a page about discard for opensuse that you might find worth reading:
http://en.opensuse.org/SDB:SSD_discard_%28trim%29_support

Greg
