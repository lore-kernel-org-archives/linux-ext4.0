From: Jens Axboe <axboe@fb.com>
Subject: Re: ext4 filesystem corruption with 4.10-rc2 on ppc64le
Date: Wed, 4 Jan 2017 08:09:28 -0700
Message-ID: <ab00525e-50d6-de22-c83c-992985297309@fb.com>
References: <20170104161808.5ad7b4fd@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
To: Anton Blanchard <anton@samba.org>, <jack@suse.cz>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul Mackerras" <paulus@samba.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170104161808.5ad7b4fd@kryten>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 01/03/2017 10:18 PM, Anton Blanchard wrote:
> Hi,
> 
> I'm consistently seeing ext4 filesystem corruption using a mainline
> kernel. It doesn't take much to trigger it - download a ppc64le Ubuntu
> cloud image, boot it in KVM and run:
> 
> sudo apt-get update
> sudo apt-get dist-upgrade
> sudo reboot
> 
> And it never makes it back up, dying with rather severe filesystem
> corruption.
> 
> I've narrowed it down to:
> 
> 64e1c57fa474 ("ext4: Use clean_bdev_aliases() instead of iteration")
> e64855c6cfaa ("fs: Add helper to clean bdev aliases under a bh and use it")
> ce98321bf7d2 ("fs: Remove unmap_underlying_metadata")
> 
> Backing these patches out fixes the issue.

Fix is going out today, I see Chandan already pointed you at it. For the
other reporter, it's not an LE vs BE thing, it's a fs blocksize < page
size problem.

-- 
Jens Axboe
