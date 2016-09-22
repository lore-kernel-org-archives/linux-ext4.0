From: Richard Weinberger <richard@nod.at>
Subject: Re: ext4, f2fs: fscrypt_has_permitted_context() check in file open
Date: Thu, 22 Sep 2016 16:21:30 +0200
Message-ID: <0216ba94-eb55-9617-9b0d-32b92ee41ec5@nod.at>
References: <6789d30e-f95d-d8bd-cd6e-664a89c0dfd1@nod.at>
 <20160922134433.w3riey2mhtvs54dx@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Gstir <david@sigma-star.at>
To: Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160922134433.w3riey2mhtvs54dx@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted,

On 22.09.2016 15:44, Theodore Ts'o wrote:
> On Thu, Sep 22, 2016 at 02:24:35PM +0200, Richard Weinberger wrote:
>> Why do we need this check? AFAIK this situation can never happen unless due to
>> a bug in the filesystem code.
> 
> Or in the case of a malicious attacker who is trying to achieve an
> off-line attack on your file system....  applications aren't going to
> be checking to see if they are writing their file with encryption
> enabled (and with the correct key), because they will largely be
> encryption oblivious.
> 
> So imagine a case where you have a file, say, dissidents.txt.  This
> file is encrypted, and is in a encrypted directory.  The bad guy, in
> an offline attack (e.g., using a tool like debugfs), creates a
> replacement directory which is unencrypted, and creates a link to the
> encrypted dissidents.txt file to that replacement directory.
> 
> You then go back to your hotel room in Beijing, boot your laptop, fire
> up your editor, and then edit the dissidents.txt file.  You have the
> keys, so it is read in just fine into vi or emacs.  But when when you
> write out the file, the editor writes the file into
> dissidents.txt.new, calls fsync on it, and then renames dissidents.txt
> to dissidents.txt~, and renames dissidents.txt.new to dissidents.txt.
> But since it is now in an unencrypted directory, dissidents.txt is now
> unencrypted.

Got it. So, the use case is preventing off-line attacks.
But I fear this is only a drop in the bucket. What we really need is
meta data authentication.

Thanks,
//richard
