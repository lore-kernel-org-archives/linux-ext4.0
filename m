From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: ext4 non-kernel standalone dev version for testing
Date: Fri, 1 May 2015 20:31:22 +0200
Message-ID: <mi0gpq$mpk$1@ger.gmane.org>
References: <mhukt7$9ce$1@ger.gmane.org> <20150501141322.GA9936@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20150501141322.GA9936@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Ts'o wrote on 05/01/2015 04:13 PM:
> On Fri, May 01, 2015 at 03:29:11AM +0200, U.Mutlu wrote:
>> can the developer-version (ie. that with the crypto extension) be tested
>> outside the kernel?
>> Ie. testing with file type filesystem, ie. file.img, on a system with old kernel.
>
> No, but you can test under KVM.  This is how I normally do most of my
> ext4 development.  Things are a little complicated at the moment
> because some e2fsprogs changes are needed that aren't in the binaries
> in the kvm-xfstests image, but I'll try to get a new version sent out
> soon.
>
> 						- Ted
>
>
> Quick start instructions for kvm-xfstests
...


Thx, but unfortunately the Makefile reports an error:

...
checking for attr_list_by_handle in -lhandle... yes
checking attr/xattr.h usability... no
checking attr/xattr.h presence... no
checking for attr/xattr.h... no

FATAL ERROR: attr/xattr.h does not exist.
Install the extended attributes (attr) development package.
Alternatively, run "make install-dev" from the attr source.
Makefile:83: recipe for target 'include/builddefs' failed
make[1]: *** [include/builddefs] Error 1
make[1]: Leaving directory '/root/ext4crypto-test/fstests/xfstests-dev'


root@c22:/root/ext4crypto-test/fstests/attr# find . -iname "*xattr*" -ls
35786444    4 -rw-r--r--   1 root     root         2297 May  1 18:52 
./include/xattr.h


root@c22:/root/ext4crypto-test/fstests/attr/include# ls -l
total 60
lrwxrwxrwx 1 root root    1 May  1 19:46 attr -> .
-rw-r--r-- 1 root root 7232 May  1 18:52 attributes.h
-rw-r--r-- 1 root root 2180 May  1 19:46 builddefs
-rw-r--r-- 1 root root 2155 May  1 18:52 builddefs.in
-rw-r--r-- 1 root root 4633 May  1 18:52 buildmacros
-rw-r--r-- 1 root root 1728 May  1 18:52 buildrules
-rw-r--r-- 1 root root 1344 May  1 19:40 config.h
-rw-r--r-- 1 root root 1282 May  1 18:52 config.h.in
-rw-r--r-- 1 root root  846 May  1 18:52 error_context.h
-rw-r--r-- 1 root root  688 May  1 18:52 libattr.h
-rw-r--r-- 1 root root  521 May  1 18:52 Makefile
-rw-r--r-- 1 root root  340 May  1 18:52 misc.h
-rw-r--r-- 1 root root 1272 May  1 18:52 walk_tree.h
-rw-r--r-- 1 root root 2297 May  1 18:52 xattr.h


Where/how should I fix this xattr.h build-bug?

System is debian 8 x86_64, testing in a chrooted environment (lxc app container).

cu
Uenal
