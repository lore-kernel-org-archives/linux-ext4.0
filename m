From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Tue, 18 Mar 2008 11:06:50 -0500
Message-ID: <47DFE89A.3080402@redhat.com>
References: <E1JRpaN-0000Bs-4N@closure.thunk.org> <47BC76A9.307@redhat.com> <20080220222019.GG30305@mit.edu> <47DEE2AE.1050105@redhat.com> <20080318022053.GL8368@mit.edu> <47DF35CC.7020604@redhat.com> <20080318042339.GO8368@mit.edu> <47DF5045.1000108@redhat.com> <20080318110145.GQ8368@mit.edu> <47DFBF84.5070207@redhat.com> <20080318135254.GA27000@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938160AbYCSVms (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2008 17:42:48 -0400
In-Reply-To: <20080318135254.GA27000@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> So what do people think about this proposal as an alternative to
> what's been discussed?
> 
> The filesystem type comes from defaults.fstype in mke2fs.conf, which
> can be overridden by /sbin/mkfs.*, which in turn can be overriden by
> the -t option.  If the the filesystem type does not begin with the
> string "ext" it will be rejected with an error.  Call this the
> "fs_type".
> 
> In addition, a list of types can be specified by the user using the -T
> flag.  Call it "type_list", and it consists of one or more usage types
> separated by commas.  If a type_list is not specified by -T, mke2fs
> use a single type based on the size of the block device, selected from
> the list "floppy, small, default".
> 
> Mke2fs will search mke2fs.conf for configuration parameters first by
> looking at the fs_type, and then successively in the usage types found
> in type_list.  Parameters found later override earlier parameters.
> 
> I can get behind this, as it's compatible with what came before, and
> simpler in the general case, and still as expressive for power users
> who want to do really complex things in their mke2fs.conf file.
> 
> What do people think?

Ted, this sounds good to me.

-Eric
