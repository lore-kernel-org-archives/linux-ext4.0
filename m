From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Test ext4/001
Date: Thu, 22 Oct 2015 11:26:49 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1510221123440.14649@localhost.localdomain>
References: <20151022091017.GC14445@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20151022091017.GC14445@quack.suse.cz>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 22 Oct 2015, Jan Kara wrote:

> Date: Thu, 22 Oct 2015 11:10:17 +0200
> From: Jan Kara <jack@suse.cz>
> To: linux-ext4@vger.kernel.org
> Cc: fstests@vger.kernel.org
> Subject: Test ext4/001
> 
> Hi,
> 
> I've checked why test ext4/001 fails for me with DAX and after some
> investigation I've realized that the test assumes that
> extent_max_zeroout_kb is 32 KB and thus unwritten extent will get converted
> to written as a whole and not split. With DAX that doesn't happen (because
> of difference between EXT4_GET_BLOCKS_ flags passed in writeback path and
> DAX write path) and so the result differs.
> 
> So I was wondering how to best fix this. Either we could switch
> extent_max_zeroout_kb to 0 to make the result same (but that has a slight
> disadvantage that we would lose testing of the zeroout logic) or we could
> increase file size so that zeroout doesn't trigger or something else?
> Anyone has some idea?
> 
> 								Honza

I'd rather still keep the test to exercise the zeroout logic,
because we've already had problems there and they may occur in the
future as well.

The easiest solution would be to create new test with zeroout turned
off and skip the old test for DAX and keep the current test as it is.

Thanks!
-Lukas
