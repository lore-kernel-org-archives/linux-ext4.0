From: Jon Burgess <jburgess777@googlemail.com>
Subject: Re: optimising filesystem for many small files
Date: Sun, 18 Oct 2009 12:25:10 +0100
Message-ID: <1255865110.27380.52.camel@localhost.localdomain>
References: <84c89ac10910162352x5cdeca37icfbf0af2f2325d7c@mail.gmail.com>
	 <4AD9D599.3000306@redhat.com>
	 <84c89ac10910171056i773dfb93wc2e917a086dd8ef0@mail.gmail.com>
	 <20091017222619.GA10074@mit.edu>
	 <84c89ac10910180231p202fb5f1r2e192e9ac0b51509@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	ext3-users@redhat.com
To: Viji V Nair <viji@fedoraproject.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:35536 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbZJRLZJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Oct 2009 07:25:09 -0400
Received: by ewy4 with SMTP id 4so665187ewy.37
        for <linux-ext4@vger.kernel.org>; Sun, 18 Oct 2009 04:25:12 -0700 (PDT)
In-Reply-To: <84c89ac10910180231p202fb5f1r2e192e9ac0b51509@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2009-10-18 at 15:01 +0530, Viji V Nair wrote:
> The application which we are using are modified versions of mapnik and
> tilecache, these are single threaded so we are running 4 process at a
> time. 

If your tiles use the OpenStreetMap / Google style 900913 projection
then you could consider using mod_tile[1]. This renders and stores each
block of 8 x 8 PNG map tiles inside a single file on the disk. This
makes the storage and access much more efficient. It cuts down the
number of files on the disk by 64 and allows nearby tiles to be read
from a single file.

	Jon

1: http://wiki.openstreetmap.org/wiki/Mod_tile


