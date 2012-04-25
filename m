From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] implement uid and gid mount options for ext2, ext3 and
 ext4
Date: Wed, 25 Apr 2012 15:10:33 -0500
Message-ID: <4F985A39.4060804@landley.net>
References: <1335281356-2943-1-git-send-email-ludwig.nussel@suse.de> <4F971936.6070809@landley.net> <4F97E5F2.50501@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	"Jan Kara (maintainer:EXT2 FILE SYSTEM)" <jack@suse.cz>,
	"Andrew Morton (maintainer:EXT3 FILE SYSTEM)"
	<akpm@linux-foundation.org>,
	"Andreas Dilger (maintainer:EXT3 FILE SYSTEM)"
	<adilger.kernel@dilger.ca>,
	"\"Theodore Ts'o\" (maintainer:EXT4 FILE SYSTEM)" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-doc@vger.kernel.org
To: Ludwig Nussel <ludwig.nussel@suse.de>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <4F97E5F2.50501@suse.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/25/2012 06:54 AM, Ludwig Nussel wrote:
> Rob Landley wrote:
>> On 04/24/2012 10:29 AM, Ludwig Nussel wrote:
>>> Further development of a patch I sent years ago. I didn't find the
>>> time to address the concerns raised back then and forgot about the
>>> patch. Now here it is again.
>>
>> The doc bits look fine:
>>
>> Acked-by: Rob Landley <rob@landley.net>
>>
>> As for the design: why isn't this in the VFS instead of in ext234? It
>> seems like VFAT is more likely to need this, and I vaguely recall virtfs
>> (I.E. 9pfs) doing something similar...?
> 
> Yes, file systems like FAT that do not store ownership information
> themselves have a uid option. I agree that handling that in vfs itself
> would be the more generic solution. It would require more work though.

The right thing to do is often more work.  If it allows us to remove
existing duplicate code, even better...

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
