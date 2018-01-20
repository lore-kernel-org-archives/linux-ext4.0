From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Panic with ext4,nbd,qemu-img,block
Date: Sat, 20 Jan 2018 18:40:28 -0500
Message-ID: <20180120234028.GB4451@thunk.org>
References: <0555d0c0-1f42-e78f-28ab-6c7a00f0c020@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org
To: "Hongzhi, Song" <hongzhi.song@windriver.com>
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0555d0c0-1f42-e78f-28ab-6c7a00f0c020@windriver.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jan 20, 2018 at 04:41:00PM +0800, Hongzhi, Song wrote:
> 
> 329.11 EXT4-fs (nbd0): mounted filesystem with ordered data mode. Opts:
> (null)
> 329.12 block nbd0: Connection timed out
> 329.13 block nbd0: shutting down sockets

That's your problem.  I'm guessing qemu-nbd is dying for some reason,
which is causing the nbd device to fail (hence the "connection timed
out").

						- Ted
