From: Andrew Watts <akwatts@ymail.com>
Subject: Re: [OOPS]: Kernel 3.1 (ext3?)
Date: Mon, 14 Nov 2011 15:53:24 -0500
Message-ID: <20111114205304.GA5542@zeus>
References: <20111110132929.GA11417@zeus>
 <20111114195352.GB17328@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm2-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.248]:48963 "HELO
	nm2-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751346Ab1KNUzU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Nov 2011 15:55:20 -0500
Content-Disposition: inline
In-Reply-To: <20111114195352.GB17328@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 14, 2011 at 08:53:52PM +0100, Jan Kara wrote:
>   Hmm, the report is missing a line (top one) saying why the kernel
> actually crashed. Can you add that?
> 
>   Also it seems you are using SLUB allocator, right? This seems like a
> problem there so adding some CCs.

Hi Jan.

Unfortunately, the oops trace is a transcription of all that was left on
my screen. I hope that can provide enough clues into what is going on.

Yes, I use the SLUB allocator.

Thank you for your reply and for adding revelant cc's.

~ Andy

