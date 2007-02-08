From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH 3/3] Online defrag command
Date: Thu, 8 Feb 2007 14:56:21 +0100
Message-ID: <20070208135620.GF4487@kernel.dk>
References: <20070208180235sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Takashi Sato <sho@tnes.nec.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070208180235sho@rifu.tnes.nec.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 08 2007, Takashi Sato wrote:
> The defrag command.  Usage is as follows:
> o Put the multiple files closer together.
>   # e4defrag -r directory-name
> o Defrag for a single file.
>   # e4defrag file-name
> o Defrag for all files on ext4.
>   # e4defrag device-name

Would it be possible to provide support for putting multiple files close
together? Ala

# e4defrag file1 file2 file3 ... fileN

I'm thinking boot speedup, gather the list of read files and put them
close on disk.

-- 
Jens Axboe

