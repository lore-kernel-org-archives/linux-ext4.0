From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Return EIO on read error in ext4_find_entry
Date: Fri, 23 Jun 2017 00:43:14 -0400
Message-ID: <20170623044314.7f23ighkelnpgnah@thunk.org>
References: <20170622232307.48392-1-khazhy@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Khazhismel Kumykov <khazhy@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170622232307.48392-1-khazhy@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 22, 2017 at 04:23:07PM -0700, Khazhismel Kumykov wrote:
> Previously, a read error would be ignored and we would eventually return
> NULL from ext4_find_entry, which signals "no such file or directory". We
> should be returning EIO.
> 
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>

Thanks, applied.

						- Ted
