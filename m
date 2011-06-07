From: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Subject: Re: Kernel BUG when syncing ext2 if USB stick is removed
Date: Tue, 07 Jun 2011 12:32:39 +0200
Message-ID: <4DEDFE47.50203@secunet.com>
References: <4DCBF4B0.10607@secunet.com>	 <20110512144255.5c4d4e84.akpm@linux-foundation.org> <1305237556.2575.98.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Maciej Rutecki <maciej.rutecki@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1305237556.2575.98.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am 12.05.2011 23:59, schrieb James Bottomley:

> This one actually doesn't look like a direct consequence, if it's list
> corruption.  If the bdi got prematurely freed, then there's a ref
> counting error in our model somewhere and the sdev patch just exposed
> it.  Since it should be easily reproducible, I'll see if I can track it
> down.

I can no longer reproduce the problem with:

commit e73e079bf128d68284efedeba1fbbc18d78610f9
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Wed May 25 15:52:14 2011 -0500

    [SCSI] Fix oops caused by queue refcounting failure

applied. I tested it both with 3.0rc2 (fix included) and v2.6.39.1
(cherry-picked).

	Torsten

BTW: Updated https://bugzilla.kernel.org/show_bug.cgi?id=35162 as well
