From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: ext4: Delete an error message for a failed memory allocation in
 ext4_multi_mount_protect()
Date: Sat, 19 Aug 2017 20:00:31 +0200
Message-ID: <e522d9a5-4d5a-b4a1-fe94-bb3aae4c5976@users.sourceforge.net>
References: <ca49a6dc-f2ee-d427-5f16-052706277b38@users.sourceforge.net>
 <5bf432ae-398d-718c-8105-3092a240a8ef@users.sourceforge.net>
 <b21f6c3d-2cad-3f72-f410-f608ea5f4cea@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: Eric Sandeen <esandeen@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b21f6c3d-2cad-3f72-f410-f608ea5f4cea@redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>> Omit an extra message for a memory allocation failure in this function.
> 
> I might be dense, but what makes this message "extra?"
> 
> (I suppose kmalloc squawks too if it fails,

Do you find the default allocation failure report sufficient?


> but is Coccinelle now warning about explicit memory allocation failure warnings?)

This software tool can help to find source code places for further
development considerations. Would you like to clarify a corresponding
search pattern a bit more?

Regards,
Markus
