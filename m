From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] ubifs: Wait for page writeback to provide stable
 pages
Date: Wed, 23 Jan 2013 13:43:12 -0800
Message-ID: <20130123134312.b69c53cd.akpm@linux-foundation.org>
References: <20130119011231.20902.55954.stgit@blackbox.djwong.org>
	<20130119011316.20902.56721.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
	martin.petersen@oracle.com, Artem Bityutskiy <dedekind1@gmail.com>,
	neilb@suse.de, Adrian Hunter <adrian.hunter@intel.com>,
	david@fromorbit.com, gnehzuil.liu@gmail.com,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	linux-mtd@lists.infradead.org, linux-ext4@vger.kernel.org,
	hirofumi@mail.parknet.co.jp
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab3AWVnO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jan 2013 16:43:14 -0500
In-Reply-To: <20130119011316.20902.56721.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 18 Jan 2013 17:13:16 -0800
"Darrick J. Wong" <darrick.wong@oracle.com> wrote:

> When stable pages are required, we have to wait if the page is just
> going to disk and we want to modify it. Add proper callback to
> ubifs_vm_page_mkwrite().
> 
> CC: Artem Bityutskiy <dedekind1@gmail.com>
> CC: Adrian Hunter <adrian.hunter@intel.com>
> CC: linux-mtd@lists.infradead.org
> From: Jan Kara <jack@suse.cz>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

A couple of these patches had this From:Jan strangely embedded in the
signoff area.  I have assumed that they were indeed authored by Jan.

Please note that authorship is indicated by putting the From: line
right at the start of the chagnelog.


I grabbed the patches.  They should appear in linux-next tomorrow if I
can get the current pooppile to build.

