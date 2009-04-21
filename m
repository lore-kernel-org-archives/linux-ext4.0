From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 0/3] Fix resize2fs data/filesystem corruption bugs
Date: Tue, 21 Apr 2009 18:57:55 -0500
Message-ID: <49EE5D83.40502@redhat.com>
References: <1240110228-22781-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58355 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbZDUX6j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Apr 2009 19:58:39 -0400
In-Reply-To: <1240110228-22781-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> These patches fix some nasty resize2fs bugs when growing or shrinking
> ext4 filesystems off-line.  Eric, you'll probably want get these
> patches into Fedora's e2fsprogs before F11 goes live.

Thanks for the heads up Ted -

FWIW, the livecd creation process, which does a fair bit of offline
resizing (shrinking), was indeed seeing corruption, and these patches do
seem to resolve it.  (I will soon be recommending that the final livecd
image be fsck'd, as it gets subsequently dd'd to thousands of hard
drives during the livecd install process!)

-Eric
