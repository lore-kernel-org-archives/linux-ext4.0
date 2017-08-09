From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: Release of e2fsprogs 1.43.5
Date: Wed, 9 Aug 2017 16:58:45 -0700
Message-ID: <552dd796-7ba5-6a10-b9fd-0d1a2aa07041@redhat.com>
References: <20170805163409.y5ifkldbmwzy4hge@thunk.org>
Reply-To: sandeen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752171AbdHIX6q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 9 Aug 2017 19:58:46 -0400
In-Reply-To: <20170805163409.y5ifkldbmwzy4hge@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/5/17 9:34 AM, Theodore Ts'o wrote:
> I've released e2fsprogs 1.43.5 in all of the usual places; it's tagged
> in the git trees on git.kernel.org, github, and sourceforge, and
> available for download at:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.43.5
> 
> and
> 
> http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.43.5.tar.gz
> 
> The release notes for 1.43.5 can be found below.

I'm getting test failures in rawhide with this, FWIW; on i686
and arm:

336 tests succeeded	3 tests failed
Tests failed: f_del_dup_quota f_quota f_quota_extent_opt 

Haven't dug into this yet (failures are on ephemeral build root
on a build host), but has anyone else seen problems?

Thanks,
-Eric
