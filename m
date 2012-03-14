From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Wed, 14 Mar 2012 10:48:17 +0800
Message-ID: <CAGBYx2ZQk+kobPj5ff0NKEfK_-kD0NK4WiNUruF=d443PV-NSw@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
	<BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com>
	<20120310044804.GB5652@thunk.org>
	<4F5F9A97.5060404@ubuntu.com>
	<20120313195339.GA24124@thunk.org>
	<4F5FAC9C.9070607@gmail.com>
	<20120313213304.GB11969@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Ted Ts'o" <tytso@mit.edu>, Phillip Susi <phillsusi@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35085 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030391Ab2CNCsS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Mar 2012 22:48:18 -0400
In-Reply-To: <20120313213304.GB11969@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

What if we use inode number as the hash value?  Does it work?

Yongqiang.
