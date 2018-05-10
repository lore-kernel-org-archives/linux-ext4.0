From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: make =?utf-8?Q?function_?=
 =?utf-8?B?4oCYZXh0NF9nZXRmc21hcF9maW5kX2ZpeGVkX21ldGFkYXRh4oCZ?= static
Date: Thu, 10 May 2018 11:50:16 -0400
Message-ID: <20180510155016.GC8335@thunk.org>
References: <20180505200452.18962-1-malat@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mathieu Malaterre <malat@debian.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180505200452.18962-1-malat@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, May 05, 2018 at 10:04:52PM +0200, Mathieu Malaterre wrote:
> Since function ‘ext4_getfsmap_find_fixed_metadata’ can be made static,
> make it so. Remove the following gcc warning (W=1):
> 
>   fs/ext4/fsmap.c:405:5: warning: no previous prototype for ‘ext4_getfsmap_find_fixed_metadata’ [-Wmissing-prototypes]
> 
> Signed-off-by: Mathieu Malaterre <malat@debian.org>

Applied, thanks.

						- Ted
