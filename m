From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs:ext4:hash.c: reduce one "if" comparison
Date: Fri, 1 Feb 2013 22:34:56 -0500
Message-ID: <20130202033456.GB16364@thunk.org>
References: <1354404821-6781-1-git-send-email-dinggnu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Cong Ding <dinggnu@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1354404821-6781-1-git-send-email-dinggnu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Dec 01, 2012 at 11:33:41PM +0000, Cong Ding wrote:
> it is unnecessary to check i<4 after the loop. just do it before the break.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>

Thanks, applied.

					- Ted
