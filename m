From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 3/6] ubifs: Use 64bit readdir cookies
Date: Thu, 29 Dec 2016 16:49:54 +0100
Message-ID: <fe46ea3c-ef8f-40ba-f4ab-8dfe8faafb0b@nod.at>
References: <1480629741-18375-1-git-send-email-richard@nod.at>
 <1480629741-18375-4-git-send-email-richard@nod.at>
 <20161229025835.GC21325@fieldses.org>
 <bf60916c-e0f2-387c-ce21-325ad8977539@nod.at>
 <20161229153407.GA29149@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-mtd@lists.infradead.org, david@sigma-star.at, tytso@mit.edu,
        dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20161229153407.GA29149@fieldses.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Bruce,

On 29.12.2016 16:34, J. Bruce Fields wrote:
>> That way UBIFS can provide a 64bit readdir() cookie which is required for NFS3.
> 
> Sounds good.  And if a matching entry isn't found (as in the case of a
> concurrent unlink), what happens?  The answer must be the same as for
> ext4, but I've forgotten the details....  I guess it must find the next
> highest cookie (thinking of the cookie as a 64-bit integer of some kind)
> that exists in the directory.  And that must be the same order that
> readdir normally returns entries in.

If a 64bit cookie is not found, the lookup function returns -ENOENT.
In UBIFS we cannot just select a higher or lower key (cookie in this case),
since it is the B-tree key and would point to a completely different
entry.

So, in case of a concurrent unlink() one would succeed and one fail with
-ENOENT. Unless I miss something that seems okay to me.

Thanks,
//richard
