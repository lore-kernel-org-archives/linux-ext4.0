From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Date: Thu, 4 Jun 2009 00:30:06 +0200
Message-ID: <20090603223005.GA9050@atrey.karlin.mff.cuni.cz>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, akpm@linux-foundation.org,
	hirofumi@mail.parknet.co.jp, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	adrian.hunter@nokia.com, artem.bityutskiy@nokia.com
To: Denis Karpov <ext-denis.2.karpov@nokia.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

> 2. Make FAT and EXT2 file systems use the above mechanism to optionally
>    notify user space about errors. Implemented as 'notify' mount option
>    (PATCH 3,4).
>    FAT error reporting facilities had to be re-factored (PATCH 2) in 
>    order to simplify sending error notifications.
  One question: Why would not a filesystem / admin want the notification
to be sent? Or in other words what's the point of the mount option?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
