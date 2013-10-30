From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: drop unsed reclen variable from
 ext4_add_dirent_to_inline()
Date: Wed, 30 Oct 2013 14:29:04 -0400
Message-ID: <20131030182904.GA31683@thunk.org>
References: <1379535450-31253-1-git-send-email-a3at.mail@gmail.com>
 <20131030145523.GD3305@thunk.org>
 <CAG5DWoi5DRCTos8-9aiLVEMf9SFc293nPj4bS0Sq6EdGsOqeYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: open list <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG5DWoi5DRCTos8-9aiLVEMf9SFc293nPj4bS0Sq6EdGsOqeYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 30, 2013 at 09:02:35PM +0400, Azat Khuzhin wrote:
> 
> Thank you!
> But there is a typo in subject, s/unsed/unused/ could you fix or it,
> or tell me, and I will resend it?

I had already reworeded the commit description as follows:

    ext4: drop set but otherwise unused variable from ext4_add_dirent_to_inline()
    
    Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Cheers,

						- Ted
