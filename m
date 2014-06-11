From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH 2/2] ext4: fix bug in ext4_mb_normalize_request()
Date: Wed, 11 Jun 2014 10:47:19 +0200
Message-ID: <20140611084719.GA6931@dhcp-27-189.brq.redhat.com>
References: <1393855228-13592-1-git-send-email-mlombard@redhat.com>
 <1393855228-13592-3-git-send-email-mlombard@redhat.com>
 <20140306154407.GA28226@thunk.org>
 <20140306165416.GA2182@dhcp-27-189.brq.redhat.com>
 <alpine.LFD.2.00.1403061842240.2249@localhost.localdomain>
 <20140526165010.GN22284@thunk.org>
 <alpine.LFD.2.00.1406032040210.2095@localhost.localdomain>
 <20140603203639.GB25483@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaFKIr0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2014 04:47:26 -0400
Content-Disposition: inline
In-Reply-To: <20140603203639.GB25483@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 03, 2014 at 04:36:39PM -0400, Theodore Ts'o wrote:
> On Tue, Jun 03, 2014 at 08:43:40PM +0200, Luk=C3=A1=C5=A1 Czerner wro=
te:
> >=20
> > I think that leaving the alignment of the start offset for the smal=
l
> > files/allocation is not good idea. We might end up with suboptimal
> > file layout for smaller files. While this is not a big deal for
> > bigger files, with smaller ones it might cause some troubles.
>=20
> I thought we were only aligning the start offset for files > 2MB?
>

That's true.

With my patch the behaviour changes slightly because it doesn't depend
only from the file size but also from the number of blocks per group.

So, if you create a filesystem with blocksize=3D=3D1Kb and 1024 blocks =
per group, we will start
aligning the start offset for files with size > 1Mb (1Kb * 1024)

The alignment is not performed on small files unless you have
a very low number of blocks per group.

Maurizio Lombardi

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
