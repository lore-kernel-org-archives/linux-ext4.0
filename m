From: Jens Axboe <axboe@fb.com>
Subject: Re: ext4 filesystem corruption with 4.10-rc2 on ppc64le
Date: Wed, 4 Jan 2017 09:23:19 -0700
Message-ID: <dc15451c-3c5e-1f61-f108-cea3c08332a9@fb.com>
References: <20170104161808.5ad7b4fd@kryten>
 <6085340.JSrffQ0Szo@localhost.localdomain>
 <20170104152837.wdh7cdncs7gyged7@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, <jack@suse.cz>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170104152837.wdh7cdncs7gyged7@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 01/04/2017 08:28 AM, Theodore Ts'o wrote:
> On Wed, Jan 04, 2017 at 11:32:42AM +0530, Chandan Rajendra wrote:
>> On Wednesday, January 04, 2017 04:18:08 PM Anton Blanchard wrote:
>>> I'm consistently seeing ext4 filesystem corruption using a mainline
>>> kernel. It doesn't take much to trigger it - download a ppc64le Ubuntu
>>> cloud image, boot it in KVM and run:
>>>
>>> sudo apt-get update
>>> sudo apt-get dist-upgrade
>>> sudo reboot
>>>
>>> And it never makes it back up, dying with rather severe filesystem
>>> corruption.
>>
>> The patch at https://patchwork.kernel.org/patch/9488235/ should fix the
>> bug.
> 
> It looks like this patch is already queued up on the "for-linus"
> branch on the linux-block.git tree.
> 
> Chandra, thanks for pointing this out!  I had missed your e-mail from
> Christmas day, and it was on my todo list to figure out why I was
> seeing lots of 1k block regressions on gce-xfstests post-merge window
> that wasn't showing up on the ext4.git tree before I sent my pull
> request to Linus.
> 
> Jens, could you expedite a pull request to Linus?  This is affecting
> ext4 on 1k block file systems on x86/x86_64, so this is not a ppc-only
> regression.  

Yes, it'll go out this morning.

-- 
Jens Axboe

