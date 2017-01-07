From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH v2] fscrypt: Factor out bio specific functions
Date: Sat, 7 Jan 2017 23:40:15 +0100
Message-ID: <21de1dd8-b491-8c59-e874-6834978f1e2e@nod.at>
References: <20161219103929.GA16197@infradead.org>
 <20161219112532.18863-1-richard@nod.at>
 <20170101214725.g67msbedmpx27waz@thunk.org>
 <dd8b8365-e84a-7f8e-384d-4900523e761e@nod.at>
 <20170103142836.no7rp3hphj3czjto@thunk.org>
 <20170104201043.GA21696@gmail.com>
 <20170107192406.56p7ppbdfkjii4vy@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Eric Biggers <ebiggers3@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jaegeuk@kernel.org, hch@infradead.org, arnd@arndb.de,
        dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        adrian.hunter@intel.com, linux-ext4@vger.kernel.org,
        ebiggers@google.com, rdunlap@infradead.org, david@sigma-star.at
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170107192406.56p7ppbdfkjii4vy@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted,

Am 07.01.2017 um 20:24 schrieb Theodore Ts'o:
> On Wed, Jan 04, 2017 at 12:10:43PM -0800, Eric Biggers wrote:
>>
>> I thought you're supposed to be able to build the kernel no matter how it's
>> configured.  If this patch is really too large for 4.10 then perhaps we should
>> make FS_ENCRYPTION select CONFIG_BLOCK instead?
> 
> We already have FS_ENCRYPTIOn depending on BLOCK, so this is *not*
> fixing a build break.

Kconfig is tricky. We face a build error with CONFIG_BLOCK=n with UBIFS_FS_ENCRYPTION enabled.
UBIFS file encryption does "select FS_ENCRYPTION" just like ext4 and f2fs.
This will enable ENCRYPTION even when no block support is available.

I can make UBIFS depend on BLOCK as intermediate fix.
But the real fix is this patch.

Thanks,
//richard
