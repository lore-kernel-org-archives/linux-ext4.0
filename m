From: Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1904, 32254 clusters in bitmap, 32258 in gd
Date: Tue, 5 Jun 2012 22:41:54 +0200
Message-ID: <1018371644.20120605224154@eikelenboom.it>
References: <471046920.20120604234941@eikelenboom.it> <20120605000356.GM29466@outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	<dm-devel@redhat.com>, <linux-ext4@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120605000356.GM29466@outflux.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Tuesday, June 5, 2012, 2:03:56 AM, you wrote:

> Hi,

> On Mon, Jun 04, 2012 at 11:49:41PM +0200, Sander Eikelenboom wrote:
>> I have enabled some debug options, this is from around when the error occurs (kernel: [  950.610126] EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1699, 32254 clusters in bitmap, 32258 in gd)

> Today I've finally managed to bisect this to here:
> [fd034a84e1ea5c8c8d159cd2089c32e792c269b0] ext4: split out ext4_free_blocks_after_init()

> If I revert all the "ext4:" patches in 3.2 up to and including that one,
> I get normal behavior again.

Hmm that seems consistent with this report which mentions 3.1.5 as last working kernel:
http://comments.gmane.org/gmane.comp.file-systems.ext4/30575

So somehow this only effects ext4 on DM (it's THE common factor in all reports) and fsck seems incapable of seeing the error (and thus repair it.)

--
Sander

> -Kees
