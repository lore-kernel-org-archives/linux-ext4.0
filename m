From: Jan Kara <jack@suse.cz>
Subject: Re: RFC: remove CONFIG_EXT4_FS_XATTR
Date: Thu, 6 Dec 2012 11:26:57 +0100
Message-ID: <20121206102657.GA16579@quack.suse.cz>
References: <nsxsj7kw2jq.fsf@closure.thunk.org>
 <50BFF5D6.7050804@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422997Ab2LFK1A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Dec 2012 05:27:00 -0500
Content-Disposition: inline
In-Reply-To: <50BFF5D6.7050804@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 06-12-12 09:33:10, Tao Ma wrote:
> On 12/06/2012 06:35 AM, Theodore Ts'o wrote:
> > 
> > The number of build warnings that were generated with the inline data
> > patch makes me think that perhaps we should just remove
> > CONFIG_EXT4_FS_XATTR.  Turning off CONFIG_EXT4_FS_XATTR causes a net
> > decrease in the ext4 file system by 27k (about 7.3% if ext4 is built as
> > a module; the entire compiled kernel's text+data size for my
> > all-in-one-no-modules-for-kvm-testing is 19 megabytes).
> > 
> > Another advantage of making this change is with the inline data option,
> > if you turn off CONFIG_EXT4_FS_XATTR, it will still allow a file system
> > with inline_data to be mounted, but then attempts to read small files or
> > small directories will end up returning EOPNOTSUPP, which will be
> > surprising to end users in a very serious way.  (Assuming it works at
> > all; I haven't tested to make sure it fails cleanly, and I'm not sure
> > Tao has tested that case either; so easing our test matrix is another
> > reason why removing this config option would be helpful.)
> To be frank, I didn't try the inline data test without xattr support. So
> that would be great if we remove it. :)
> 
> btw, does any distribution disable xattr support during kernel build? As
> Eric said on behalf of redhat, and in my ubuntu box xattr is enabled.
> Would Jan confirm that SUSE also use it by default?
  Yes, we enable xattrs in all our kernel configs... BTW +1 from me for
removing the config option.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
