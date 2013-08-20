From: Jan Kara <jack@suse.cz>
Subject: Re: On the 16TiB max file size limit (not filesystem limit)
Date: Tue, 20 Aug 2013 19:35:37 +0200
Message-ID: <20130820173537.GA5030@quack.suse.cz>
References: <521135ED.6010101@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Spelic <spelic@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab3HUHsZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Aug 2013 03:48:25 -0400
Content-Disposition: inline
In-Reply-To: <521135ED.6010101@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 18-08-13 23:00:29, Spelic wrote:
> Dear ext4 developers
> are there any plans to overcome the 16TiB maximum file size limit for ext4?
> 
> Now that resize works across 16TiB boundary, many people could be
> interested in using ext4 as a slower but safer alternative to a
> distributed filesystem for large storages. However 16TiB filesize
> limit might be a problem if one wants to do big virtualization or
> anyway somehow nesting storage systems one into the other. Is the
> limit hard to fix?
  It would mean an incompatible on disk format change in the format of
extent. So it's doable but definitely not trivial.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
