From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ixt3
Date: Tue, 17 Oct 2006 03:22:48 -0600
Message-ID: <20061017092248.GY6221@schatzie.adilger.int>
References: <20061017103617.cb1a34c2.pegasus@nerv.eu.org> <20061017085130.GX6221@schatzie.adilger.int> <20061017110637.187ae3c0.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:34241 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1423181AbWJQJWv
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Oct 2006 05:22:51 -0400
To: Jure =?utf-8?B?UGXEjWFy?= <pegasus@nerv.eu.org>
Content-Disposition: inline
In-Reply-To: <20061017110637.187ae3c0.pegasus@nerv.eu.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 17, 2006  11:06 +0200, Jure Pe=C4=8Dar wrote:
> On Tue, 17 Oct 2006 02:51:30 -0600
> Andreas Dilger <adilger@clusterfs.com> wrote:
> > None of the retry code has been looked at.
>=20
> This is what I'm mostly interested in ... predictable, well behaving
> and tested error handling & recovery. Is ext4 going to be any better
> here than ext3?

Not unless someone massages the ixt3 code into a form usable in the
kernel.  I'd suggest you contact the authors if you are interested in
doing this work.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
