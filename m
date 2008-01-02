From: Diego Calleja <diegocg@gmail.com>
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
Date: Wed, 2 Jan 2008 19:26:29 +0100
Message-ID: <20080102192629.28e67241.diegocg@gmail.com>
References: <20080102013218.GO27566@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:53774 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYABS1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jan 2008 13:27:12 -0500
Received: by fg-out-1718.google.com with SMTP id e21so3200068fga.17
        for <linux-ext4@vger.kernel.org>; Wed, 02 Jan 2008 10:27:11 -0800 (PST)
In-Reply-To: <20080102013218.GO27566@does.not.exist>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

El Wed, 2 Jan 2008 03:32:18 +0200, Adrian Bunk <bunk@kernel.org> escrib=
i=F3:

> It might make sense to offer ext4 in -mm and even in early -rc kernel=
s,=20
> but I've already seen people using ext4 simply because a stable kerne=
l=20
> offered it - and that's definitely not intended.

But isn't that the whole purpose of having ext4 snapshots in the stable=
 kernel - to
allow people to try it?
