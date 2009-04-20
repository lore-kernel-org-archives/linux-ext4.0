From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup
 blocks...
Date: Mon, 20 Apr 2009 19:55:05 +0100 (BST)
Message-ID: <alpine.LFD.2.00.0904201953260.30497@xpc17.ast.cam.ac.uk>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com> <gshfgl$o6m$1@ger.gmane.org> <20090420113534.GR19186@mit.edu> <alpine.LFD.2.00.0904201237500.17316@xpc17.ast.cam.ac.uk> <20090420124810.GT19186@mit.edu> <49EC8B97.6010308@redhat.com>
 <49EC9A11.1080105@redhat.com> <alpine.LFD.2.00.0904201652540.17316@xpc17.ast.cam.ac.uk> <20090420182800.GC3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:33254 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZDTSzI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Apr 2009 14:55:08 -0400
In-Reply-To: <20090420182800.GC3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 20 Apr 2009, Andreas Dilger wrote:

> On Apr 20, 2009  16:53 +0100, Jeremy Sanders wrote:
>> On Mon, 20 Apr 2009, Eric Sandeen wrote:
>>> One other question - do you make use of xattrs on this filesystem?
>>
>> No.
>
> If you use anything like SELinux or ACLs you would also (indirectly) be
> using xattrs.

SELinux is switched off and we haven't (knowingly) been using xattrs, but 
I remember rsync might copy copy xattrs, so perhaps they get written in 
some way...

Jeremy

-- 
Jeremy Sanders <jss@ast.cam.ac.uk>   http://www-xray.ast.cam.ac.uk/~jss/
X-Ray Group, Institute of Astronomy, University of Cambridge, UK.
Public Key Server PGP Key ID: E1AAE053
