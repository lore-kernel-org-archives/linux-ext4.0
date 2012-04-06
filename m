From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: Commit c1a1e7fc24d6 causes segfault in ext2fs_new_inode
Date: Fri, 6 Apr 2012 20:22:25 +0100
Message-ID: <20120406192225.GV27709@amd.home.annexia.org>
References: <20120330125726.GA26221@amd.home.annexia.org>
 <20120330131936.GB26221@amd.home.annexia.org>
 <4F760BC2.4070401@redhat.com>
 <20120406191401.GA8816@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Sami Liedes <sami.liedes@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab2DFUHv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Apr 2012 16:07:51 -0400
Content-Disposition: inline
In-Reply-To: <20120406191401.GA8816@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 06, 2012 at 10:14:01PM +0300, Sami Liedes wrote:
> While I suggest passing EXT2_FLAG_64BITS to ext2fs_open() - it should
> never break anything and only makes things faster [...]

Thanks -- good to know, and this is what we did to fix febootstrap.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
New in Fedora 11: Fedora Windows cross-compiler. Compile Windows
programs, test, and build Windows installers. Over 70 libraries supprt'd
http://fedoraproject.org/wiki/MinGW http://www.annexia.org/fedora_mingw
