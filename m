From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH] mke2fs, tune2fs, resize2fs: add warning messages for
 bigalloc and quota
Date: Tue, 22 Jan 2013 11:46:26 -0600
Message-ID: <50FED072.2020402@redhat.com>
References: <1358813397-26528-1-git-send-email-tytso@mit.edu> <679935ED-C84D-42C4-B6C4-2F104774FBB0@redhat.com> <355F6D97-0481-45C8-805B-F2E2BF6118F8@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab3AVRqz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2013 12:46:55 -0500
In-Reply-To: <355F6D97-0481-45C8-805B-F2E2BF6118F8@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/22/13 11:24 AM, Andreas Dilger wrote:
> My preference would be to have separate "--force-bigalloc" and
> "--force-quota" options instead of lumping everything under a single
> "--force/-f" flag. That can become habitual for one kind of usage
> (e.g. mke2fs on a regular file) and then it also forces other
> dangerous behaviour (such as these) as an unknown side effect.

Actually, that's a good point, I had the same thought and meant
to mention it but forgot. :(

I guess the release is out there now, though.

-Eric
