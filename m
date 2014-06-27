From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix punch hole on files with indirect mapping
Date: Thu, 26 Jun 2014 21:33:29 -0400
Message-ID: <20140627013329.GE6826@thunk.org>
References: <1403192228-25771-1-git-send-email-lczerner@redhat.com>
 <20140626162450.GD6826@thunk.org>
 <alpine.LFD.2.00.1406261827080.2172@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, stable@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1406261827080.2172@localhost.localdomain>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 26, 2014 at 06:28:57PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> It does. But this is not exactly a critical bug and it has been
> there since the introduction of punch hole for indirect file. But I
> guess it's better to fix it sooner rather than later, so I am fine
> with this.

One of the reasons why I want to get this fixed sooner rather than
later is that even when testing a stock ext4 file system, fsstress can
potentially create indirect mapped files that could then get punched.
So I wonder if bug might be responsible for some of the very random
failures that I've been seeing in my testing...

					- Ted
