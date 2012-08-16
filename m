From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4fs error "ext4_mb_generate_buddy:741:group 16, 8160 clusters
 in bitmap, 4064 in gd" (with repro)
Date: Thu, 16 Aug 2012 16:00:32 -0400
Message-ID: <20120816200032.GE31346@thunk.org>
References: <50238A29.3060808@redhat.com>
 <20120809170640.GA6607@thunk.org>
 <alpine.LFD.2.00.1208151116530.4904@dhcp-1-248.brq.redhat.com>
 <alpine.LFD.2.00.1208161619440.2459@vpn-8-20.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	"Linux Kernel Mailinlinux-ext4@vger.kernel.orgg List"
	<linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1208161619440.2459@vpn-8-20.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 16, 2012 at 04:28:07PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> After a little bit of tracing with the systemtap and blktrace ext4
> does not seem to be doing anything wrong and yet we get part of the
> block bitmap trimmed. This lead me to the scsi_debug driver itself
> and indeed it seems that we have off-by-one bug there in the
> unamp_region() which is causing the problem.

Thanks for finding this --- I was getting scared that ext4 users were
losing data in production.  It's good to know it was just a bug in the
scsi_debug driver.

						- Ted
