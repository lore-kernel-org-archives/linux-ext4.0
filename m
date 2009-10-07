From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH][RFC] vfs: add message print mechanism for the mount/umount
 into the VFS layer
Date: Wed, 07 Oct 2009 14:56:40 +0900
Message-ID: <4ACC2D98.8030701@jp.fujitsu.com>
References: <20091006125142.b766ad98.toshi.okajima@jp.fujitsu.com> <4ACB784A.3090604@oracle.com>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: viro@zeniv.linux.org.uk, tytso@mit.edu,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4ACB784A.3090604@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Sunil,
thank you for your comment.

Sunil Mushran wrote:
> Toshiyuki Okajima wrote:
>>       up_write(&namespace_sem);
>> +    /* +     * message output at mount for log observers
>> +     */
>> +    if (newmnt->mnt_flags & MNT_VERBOSE_MSG) {
>> +        printk(KERN_INFO "Device %s mounted file system type %s 
>> read-%s\n",
>> +                    sb->s_id, sb->s_type->name,
>> +                    sb->s_flags & MS_RDONLY ? "only" : "write");
>> +        /* fs specific messages for mount */
>> +        if (sb->s_op != NULL && sb->s_op->mount_msg != NULL)
>> +            sb->s_op->mount_msg(sb);
>> +    }
>>      return 0;
> 
> How about allowing the fs to over-ride the default message? Reduces the 
> clutter.
> Same on the umount.
> 
> 
> +    if (newmnt->mnt_flags & MNT_VERBOSE_MSG) {
> +        if (sb->s_op != NULL && sb->s_op->mount_msg != NULL)
> +            sb->s_op->mount_msg(sb);
> +        else
> +            printk(KERN_INFO "Device %s mounted file system type %s 
> read-%s\n",
> +                sb->s_id, sb->s_type->name,
> +                sb->s_flags & MS_RDONLY ? "only" : "write");
> +    }

My purpose is to print the common message on the VFS layer.
By using "sop->mount_msg" or "sop->umount_msg", we can print the additional
messages as the filesystem specific information about mount/umount operation
at the same time if necessary.

- at the mount time
[VFS mount message]     <= We can understand a certain filesystem is being
                           mounted at this moment.
[fs specific messages
...                   ] <- additional messages as the filesystem specific info
                           at the mount time.

- at the umount time
[fs specific messages   <- additional messages as the filesystem specific info
  ...                 ]    at the umount time.
[VFS umount message]     <= We can understand a certain filesystem has been
                            unmounted at this moment.

(NOTE: VFS messages == "Device ??? mounted file system type ??? read-???")

Best Regards,
Toshiyuki Okajima

