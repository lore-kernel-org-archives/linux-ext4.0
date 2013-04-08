From: Andrew Bartlett <abartlet@samba.org>
Subject: Re: [PATCH, RFC V3] ext3: add ioctl to force 32-bit hashes from
 indexed dirs
Date: Mon, 08 Apr 2013 19:28:18 +1000
Message-ID: <1365413298.7909.61.camel@jesse>
References: <5154AAB4.2000701@redhat.com> <5159A8D5.1000204@redhat.com>
	 <20130401181718.GB22443@thunk.org> <5159D03F.5000606@redhat.com>
	 <20130401190804.GD22443@thunk.org> <5159E4AC.7050307@redhat.com>
	 <20130401200052.GA24097@thunk.org> <5159E88F.8030704@redhat.com>
	 <307C00EE-45DE-48A4-9FB7-3F164B51A524@redhat.com>
	 <1365203125.15177.33.camel@jesse> <20130405232821.GA15810@pad.fieldses.org>
	 <515F5DAA.8000105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "J. Bruce Fields" <bfields@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, gluster-devel@nongnu.org,
	jra@samba.org
To: Anand Avati <avati@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fn.samba.org ([216.83.154.106]:37784 "EHLO mail.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934118Ab3DHJ2X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 05:28:23 -0400
In-Reply-To: <515F5DAA.8000105@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2013-04-05 at 16:26 -0700, Anand Avati wrote:
> On 04/05/2013 04:28 PM, J. Bruce Fields wrote:
> 
> > knfsd is still returning 32-bit cookies to v2 clients (that's the
> > protocol), but I doubt v2 support is very critical for Ganesha.
> 
> The last I heard, Ganesha has officially removed all NFSv2 code from 
> their repo and do not support it at all anymore.

I spoke with Jeremy, and we wouldn't want Samba's support for equally
old/dead protocols to stand in the way of the kernel here.  We both
agree that we can sort this out in userspace well enough (and would have
to anyway, as a there is a large deployed set of servers with this
behaviour already). 

Thank you very much to those who took the time to loop us in for giving
Samba a chance to express a view here.

Andrew Bartlett

-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org


