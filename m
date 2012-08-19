From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH] jbd2: don't write superblock when unmounting an ro filesystem
Date: Sun, 19 Aug 2012 14:54:07 -0400 (EDT)
Message-ID: <F02DAB7A-6BE5-4C74-9D69-3615CC3ADC63@redhat.com>
References: <500F1C28.8010800@redhat.com> <20120818184504.GA5382@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:44970 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab2HSSyN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Aug 2012 14:54:13 -0400
In-Reply-To: <20120818184504.GA5382@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 18, 2012, at 11:45 AM, "Theodore Ts'o" <tytso@mit.edu> wrote:

> Applied, thanks.  I updated the reproduction instructions so that they
> wored correctly.  (i.e., by removing the offset, and changing the size
> to 1g).
> 
Thanks, sorry about that really messed up commit message.  :(

-Eric

>                    - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
