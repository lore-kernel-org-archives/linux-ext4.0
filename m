From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: OpenPosix test case mmap_11-4 fails in ext4 filesystem
Date: Wed, 21 May 2014 15:01:36 -0400
Message-ID: <20140521190136.GC8868@thunk.org>
References: <537C4A2F.8040402@cn.fujitsu.com>
 <alpine.LFD.2.00.1405211413370.2114@localhost.localdomain>
 <20140521141203.GB1501@thunk.org>
 <alpine.LFD.2.00.1405211715360.2114@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org, chrubis@suse.cz
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53999 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaEUTBk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2014 15:01:40 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405211715360.2114@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 21, 2014 at 05:18:24PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> I am not disputing it, but since he seems to be using RHEL I am
> asking for the triage with Red Hat support.

Sure, it makes sence that a RH bugzilla entry be opened to make sure
that whatever eventual bug fix we have in upstream gets backported to
the RHEL 7.0RC kernel.

And sure, normally when someone uses distro-specific version
references when reporting bugs upstream, this is not the best
procedure, especially since not everyone (including me) has access to
RHEL 7.0 RC kernels.  However, I'm minded to overlook such faux pas
when the bug report is accompanied by a very nice test case which
makes it trivial to verify the problematic behavior, and that the
problem is present upstream.

Cheers,

					- ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
