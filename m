From: Tao Ma <tm@tao.ma>
Subject: Re: RFC: remove CONFIG_EXT4_FS_XATTR
Date: Thu, 06 Dec 2012 09:33:10 +0800
Message-ID: <50BFF5D6.7050804@tao.ma>
References: <nsxsj7kw2jq.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:44339 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752534Ab2LFBdU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2012 20:33:20 -0500
In-Reply-To: <nsxsj7kw2jq.fsf@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/06/2012 06:35 AM, Theodore Ts'o wrote:
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
To be frank, I didn't try the inline data test without xattr support. So
that would be great if we remove it. :)

btw, does any distribution disable xattr support during kernel build? As
Eric said on behalf of redhat, and in my ubuntu box xattr is enabled.
Would Jan confirm that SUSE also use it by default?

Thanks
Tao
