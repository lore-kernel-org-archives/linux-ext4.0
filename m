From: Chris Mason <chris.mason@oracle.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Fri, 2 Mar 2012 09:00:38 -0500
Message-ID: <20120302140038.GD5054@shiny>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
 <20120301143859.GX5054@shiny>
 <CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
To: Jacek Luczak <difrost.kernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:21491 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab2CBOAo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Mar 2012 09:00:44 -0500
Content-Disposition: inline
In-Reply-To: <CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 02, 2012 at 11:05:56AM +0100, Jacek Luczak wrote:
> 
> I've took both on tests. The subject is acp and spd_readdir used with
> tar, all on ext4:
> 1) acp: http://91.234.146.107/~difrost/seekwatcher/acp_ext4.png
> 2) spd_readdir: http://91.234.146.107/~difrost/seekwatcher/tar_ext4_readir.png
> 3) both: http://91.234.146.107/~difrost/seekwatcher/acp_vs_spd_ext4.png
> 
> The acp looks much better than spd_readdir but directory copy with
> spd_readdir decreased to 52m 39sec (30 min less).

Do you have stats on how big these files are, and how fragmented they
are?  For acp and spd to give us this, I think something has gone wrong
at writeback time (creating individual fragmented files).

-chris

