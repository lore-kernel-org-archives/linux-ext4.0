From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: Group descriptor 0 checksum is invalid
Date: Sun, 15 Nov 2009 23:27:33 -0800 (PST)
Message-ID: <alpine.DEB.2.01.0911152325370.27639@bogon.housecafe.de>
References: <alpine.DEB.2.01.0911141349050.27639@bogon.housecafe.de> <20091116031101.GP4323@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:64162 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbZKPH1d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Nov 2009 02:27:33 -0500
In-Reply-To: <20091116031101.GP4323@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 15 Nov 2009 at 22:11, Theodore Tso wrote:
> Yes, it's expected.  We may try to make tune2fs better about fixing up
> the checksums when enabling uninit_bg at some point in the future, but
> for now, it's one of the reasons why tune2fs requests that you run
> e2fsck on the file system.

Thanks for your reply, Ted. As the messages look rather troubling, I've 
documented this effect in the Wiki.

Thanks,
Christian.
-- 
BOFH excuse #411:

Traffic jam on the Information Superhighway.
