From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fixed two coding style errors, spaces required
 around =
Date: Tue, 12 May 2015 13:54:06 -0400
Message-ID: <20150512175406.GA18150@thunk.org>
References: <1423053226-10210-1-git-send-email-oscar.forner.martinez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1423053226-10210-1-git-send-email-oscar.forner.martinez@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 04, 2015 at 12:33:46PM +0000, Oscar Forner Martinez wrote:
> Two lines with assignation without spaces around the =
> 
> Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>

NACK, we don't generally take code cleanup patches unless it's part of
changes in that part of the code.  Otherwise, code cleanup patches
break other people's pending patches which are waiting code review;
and so "code cleanup" patches end up adding negative, not positive,
value.

Regards,

					- Ted
