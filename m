From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: [PATCH 1/3] ext4: sanity check the block and cluster size at
 mount time
Date: Fri, 18 Nov 2016 09:40:02 +0200
Message-ID: <955b7ea8-2fb2-a958-bb8a-5b5003668765@kyup.com>
References: <5ce3de05-2f37-6758-1178-ecf520c87d4f@kyup.com>
 <20161118042610.13464-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: bp@alien8.de, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20161118042610.13464-1-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 11/18/2016 06:26 AM, Theodore Ts'o wrote:
> If the block size or cluster size is insane, reject the mount.  This
> is important for security reasons (although we shouldn't be just
> depending on this check).
> 
> Ref: http://www.securityfocus.com/archive/1/539661
> Ref: https://bugzilla.redhat.com/show_bug.cgi?id=1332506
> Reported-by: Borislav Petkov <bp@alien8.de>
> Reported-by: Nikolay Borisov <kernel@kyup.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org

I just tested with the 3 patches applied on 4.9-rc4 and could still
reproduce the issue.
