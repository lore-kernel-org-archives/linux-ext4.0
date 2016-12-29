From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 6/6] ubifs: Wire up NFS support
Date: Thu, 29 Dec 2016 09:48:25 +0100
Message-ID: <af4b2ea5-e2fa-b454-a77e-10c62174ecff@nod.at>
References: <1480629741-18375-1-git-send-email-richard@nod.at>
 <1480629741-18375-7-git-send-email-richard@nod.at>
 <20161229025650.GB21325@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-mtd@lists.infradead.org, david@sigma-star.at, tytso@mit.edu,
        dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161229025650.GB21325@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Bruce,

On 29.12.2016 03:56, J. Bruce Fields wrote:
>> -	 * Note, d_splice_alias() would be required instead if we supported
>> -	 * NFS.
>> -	 */
>> -	d_add(dentry, inode);
>> +
>> +	d_splice_alias(inode, dentry);
>>  	return NULL;
> 
> I'm pretty sure that should be 
> 
> 	return d_splice_alias(inode, dentry);

You are right.
/me assumed d_splice_alias() is consistent with d_add(). :-(

Thanks,
//richard
