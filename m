From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: RFC: remove CONFIG_EXT4_FS_XATTR
Date: Wed, 05 Dec 2012 17:04:11 -0600
Message-ID: <50BFD2EB.9070206@redhat.com>
References: <nsxsj7kw2jq.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Tao Ma <tm@tao.ma>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab2LEXEH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Dec 2012 18:04:07 -0500
In-Reply-To: <nsxsj7kw2jq.fsf@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/5/12 4:35 PM, Theodore Ts'o wrote:
> 
> The number of build warnings that were generated with the inline data
> patch makes me think that perhaps we should just remove
> CONFIG_EXT4_FS_XATTR.  Turning off CONFIG_EXT4_FS_XATTR causes a net
> decrease in the ext4 file system by 27k (about 7.3% if ext4 is built as
> a module; the entire compiled kernel's text+data size for my
> all-in-one-no-modules-for-kvm-testing is 19 megabytes).
> 
> Another advantage of making this change is with the inline data option,
> if you turn off CONFIG_EXT4_FS_XATTR, it will still allow a file system
> with inline_data to be mounted, but then attempts to read small files or
> small directories will end up returning EOPNOTSUPP, which will be
> surprising to end users in a very serious way.  (Assuming it works at
> all; I haven't tested to make sure it fails cleanly, and I'm not sure
> Tao has tested that case either; so easing our test matrix is another
> reason why removing this config option would be helpful.)
> 
> Does anyone have any objections or other reasons why this would be a bad
> idea?

It doesn't bother me; everything in my universe builds with it on.

-Eric

>                                                 - Ted
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

