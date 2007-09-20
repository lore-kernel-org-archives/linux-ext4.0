From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Thu, 20 Sep 2007 15:22:16 -0500
Message-ID: <46F2D678.4060203@redhat.com>
References: <20070919061404.GA1628@schatzie.adilger.int> <46F1CFC0.3070801@redhat.com> <20070920050923.GX32520@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbXITUWZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2007 16:22:25 -0400
In-Reply-To: <20070920050923.GX32520@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Sep 19, 2007  20:41 -0500, Eric Sandeen wrote:
>> Andreas Dilger wrote:
>>> It isn't possible to build an e2fsprogs via "make rpm" on SuSE and have it
>>> install cleanly, because they split out some of the libraries into separate
>>> packages.
>>>
>>> We've got the current patch to the .spec file, but I'm open to discussion
>>> if it is more desirable to change the .spec to continue to build separate
>>> RPMs (though that is more of a distribution hassle and might need major
>>> changes in the .spec file).
>> FWIW, I also have an RFE assigned to me for RHEL/Fedora to split up our
>> e2fsprogs packages for libcom_err and libuuid... since many
>> non-filesystem things now require them.   So, this is sort of going in
>> the opposite direction.  :)
>>
>> Any idea how many distros already split it out?
> 
> I know Debian-based distros have done this for ages...
> 
> I'd also welcome someone with rpm-fu split it into separate packages.

I'd do this, my rpm-fu is still reasonably strong, though - I'm curious,
is there a compelling reason to split out just libcom-err?  what about
libuuid?  libblkid?  e2fsprogs is a bit of a grab bag of things.  What's
the rationale for the split?

-Eric
