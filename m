From: Frank Mayhar <fmayhar@google.com>
Subject: fsck infinite loop on corrupt ext4 file system
Date: Fri, 14 Aug 2009 16:55:05 -0700
Message-ID: <1250294105.6221.24.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-fAX7j3M1Ym34X+/P+XIh"
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:28121 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbZHNXzI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Aug 2009 19:55:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-fAX7j3M1Ym34X+/P+XIh
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello, folks.  We recently ran into a pretty severe ext4 crash (being
worked on by someone else) that caused some seriously corrupted file
systems, one of which in turn exposed an fsck problem.  We noticed this
when fsck started looping endlessly trying to correct that file system.
Basically, the group descriptors were mangled; fsck complains about
invalid checksums, forces a full check and during pass 1 tries to
allocate some inode bitmap blocks (apparently).  That allocation fails,
pass 1 errors out and starts the check over.  Endlessly.

I've attached output from the first few loops; unfortunately the file
system image is far, far too large to transport.  I've done some
analysis and it appears that check_super_block is noticing the problem
and hitting this case:

                if (gd->bg_inode_table == 0) {
                        ctx->invalid_inode_table_flag[i]++;
                        ctx->invalid_bitmaps++;
                }
                free_blocks += gd->bg_free_blocks_count;
                free_inodes += gd->bg_free_inodes_count;

(Around line 623 in super.c in the 1.41.8 source.)

Later, during pass 1, he calls handle_fs_bad_blocks due to
ctx->invalid_bitmaps being set and tries to allocate blocks for the
inode table.  This allocation fails.

I suspect that the inode table blocks in question simply aren't marked
free and certainly fsck isn't so marking them before it does the
allocate.  Should it try to first free the affected blocks?  Isn't the
inode table static?  Why is handle_fs_bad_blocks trying to reallocate it
without at least trying to free it first?
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

--=-fAX7j3M1Ym34X+/P+XIh
Content-Disposition: attachment; filename=sdi3-fsck-output
Content-Type: text/plain; name=sdi3-fsck-output; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

e2fsck 1.41.3 (12-Oct-2008)
fsck.ext2: Group descriptors look bad... trying backup blocks...
Group descriptor 256 checksum is invalid.  Fix? yes

Group descriptor 257 checksum is invalid.  Fix? yes

Group descriptor 258 checksum is invalid.  Fix? yes

Group descriptor 259 checksum is invalid.  Fix? yes

Group descriptor 260 checksum is invalid.  Fix? yes

Group descriptor 261 checksum is invalid.  Fix? yes

Group descriptor 262 checksum is invalid.  Fix? yes

Group descriptor 263 checksum is invalid.  Fix? yes

Group descriptor 264 checksum is invalid.  Fix? yes

Group descriptor 265 checksum is invalid.  Fix? yes

Group descriptor 266 checksum is invalid.  Fix? yes

Group descriptor 267 checksum is invalid.  Fix? yes

Group descriptor 268 checksum is invalid.  Fix? yes

Group descriptor 269 checksum is invalid.  Fix? yes

Group descriptor 270 checksum is invalid.  Fix? yes

Group descriptor 271 checksum is invalid.  Fix? yes

Group descriptor 272 checksum is invalid.  Fix? yes

Group descriptor 273 checksum is invalid.  Fix? yes

Group descriptor 274 checksum is invalid.  Fix? yes

Group descriptor 275 checksum is invalid.  Fix? yes

Group descriptor 276 checksum is invalid.  Fix? yes

Group descriptor 277 checksum is invalid.  Fix? yes

Group descriptor 278 checksum is invalid.  Fix? yes

Group descriptor 279 checksum is invalid.  Fix? yes

Group descriptor 280 checksum is invalid.  Fix? yes

Group descriptor 281 checksum is invalid.  Fix? yes

Group descriptor 282 checksum is invalid.  Fix? yes

Group descriptor 283 checksum is invalid.  Fix? yes

Group descriptor 284 checksum is invalid.  Fix? yes

Group descriptor 285 checksum is invalid.  Fix? yes

Group descriptor 286 checksum is invalid.  Fix? yes

Group descriptor 287 checksum is invalid.  Fix? yes

Group descriptor 288 checksum is invalid.  Fix? yes

Group descriptor 289 checksum is invalid.  Fix? yes

Group descriptor 290 checksum is invalid.  Fix? yes

Group descriptor 291 checksum is invalid.  Fix? yes

Group descriptor 292 checksum is invalid.  Fix? yes

Group descriptor 293 checksum is invalid.  Fix? yes

Group descriptor 294 checksum is invalid.  Fix? yes

Group descriptor 295 checksum is invalid.  Fix? yes

Group descriptor 296 checksum is invalid.  Fix? yes

Group descriptor 297 checksum is invalid.  Fix? yes

Group descriptor 298 checksum is invalid.  Fix? yes

Group descriptor 299 checksum is invalid.  Fix? yes

Group descriptor 300 checksum is invalid.  Fix? yes

Group descriptor 301 checksum is invalid.  Fix? yes

Group descriptor 302 checksum is invalid.  Fix? yes

Group descriptor 303 checksum is invalid.  Fix? yes

Group descriptor 304 checksum is invalid.  Fix? yes

Group descriptor 305 checksum is invalid.  Fix? yes

Group descriptor 306 checksum is invalid.  Fix? yes

Group descriptor 307 checksum is invalid.  Fix? yes

Group descriptor 308 checksum is invalid.  Fix? yes

Group descriptor 309 checksum is invalid.  Fix? yes

Group descriptor 310 checksum is invalid.  Fix? yes

Group descriptor 311 checksum is invalid.  Fix? yes

Group descriptor 312 checksum is invalid.  Fix? yes

Group descriptor 313 checksum is invalid.  Fix? yes

Group descriptor 314 checksum is invalid.  Fix? yes

Group descriptor 315 checksum is invalid.  Fix? yes

Group descriptor 316 checksum is invalid.  Fix? yes

Group descriptor 317 checksum is invalid.  Fix? yes

Group descriptor 318 checksum is invalid.  Fix? yes

Group descriptor 319 checksum is invalid.  Fix? yes

Group descriptor 320 checksum is invalid.  Fix? yes

Group descriptor 321 checksum is invalid.  Fix? yes

Group descriptor 322 checksum is invalid.  Fix? yes

Group descriptor 323 checksum is invalid.  Fix? yes

Group descriptor 324 checksum is invalid.  Fix? yes

Group descriptor 325 checksum is invalid.  Fix? yes

Group descriptor 326 checksum is invalid.  Fix? yes

Group descriptor 327 checksum is invalid.  Fix? yes

Group descriptor 328 checksum is invalid.  Fix? yes

Group descriptor 329 checksum is invalid.  Fix? yes

Group descriptor 330 checksum is invalid.  Fix? yes

Group descriptor 331 checksum is invalid.  Fix? yes

Group descriptor 332 checksum is invalid.  Fix? yes

Group descriptor 333 checksum is invalid.  Fix? yes

Group descriptor 334 checksum is invalid.  Fix? yes

Group descriptor 335 checksum is invalid.  Fix? yes

Group descriptor 336 checksum is invalid.  Fix? yes

Group descriptor 337 checksum is invalid.  Fix? yes

Group descriptor 338 checksum is invalid.  Fix? yes

Group descriptor 339 checksum is invalid.  Fix? yes

Group descriptor 340 checksum is invalid.  Fix? yes

Group descriptor 341 checksum is invalid.  Fix? yes

Group descriptor 342 checksum is invalid.  Fix? yes

Group descriptor 343 checksum is invalid.  Fix? yes

Group descriptor 344 checksum is invalid.  Fix? yes

Group descriptor 345 checksum is invalid.  Fix? yes

Group descriptor 346 checksum is invalid.  Fix? yes

Group descriptor 347 checksum is invalid.  Fix? yes

Group descriptor 348 checksum is invalid.  Fix? yes

Group descriptor 349 checksum is invalid.  Fix? yes

Group descriptor 350 checksum is invalid.  Fix? yes

Group descriptor 351 checksum is invalid.  Fix? yes

Group descriptor 352 checksum is invalid.  Fix? yes

Group descriptor 353 checksum is invalid.  Fix? yes

Group descriptor 354 checksum is invalid.  Fix? yes

Group descriptor 355 checksum is invalid.  Fix? yes

Group descriptor 356 checksum is invalid.  Fix? yes

Group descriptor 357 checksum is invalid.  Fix? yes

Group descriptor 358 checksum is invalid.  Fix? yes

Group descriptor 359 checksum is invalid.  Fix? yes

Group descriptor 360 checksum is invalid.  Fix? yes

Group descriptor 361 checksum is invalid.  Fix? yes

Group descriptor 362 checksum is invalid.  Fix? yes

Group descriptor 363 checksum is invalid.  Fix? yes

Group descriptor 364 checksum is invalid.  Fix? yes

Group descriptor 365 checksum is invalid.  Fix? yes

Group descriptor 366 checksum is invalid.  Fix? yes

Group descriptor 367 checksum is invalid.  Fix? yes

Group descriptor 368 checksum is invalid.  Fix? yes

Group descriptor 369 checksum is invalid.  Fix? yes

Group descriptor 370 checksum is invalid.  Fix? yes

Group descriptor 371 checksum is invalid.  Fix? yes

Group descriptor 372 checksum is invalid.  Fix? yes

Group descriptor 373 checksum is invalid.  Fix? yes

Group descriptor 374 checksum is invalid.  Fix? yes

Group descriptor 375 checksum is invalid.  Fix? yes

Group descriptor 376 checksum is invalid.  Fix? yes

Group descriptor 377 checksum is invalid.  Fix? yes

Group descriptor 378 checksum is invalid.  Fix? yes

Group descriptor 379 checksum is invalid.  Fix? yes

Group descriptor 380 checksum is invalid.  Fix? yes

Group descriptor 381 checksum is invalid.  Fix? yes

Group descriptor 382 checksum is invalid.  Fix? yes

Group descriptor 383 checksum is invalid.  Fix? yes

/dev/foo contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes


Error allocating 205 contiguous block(s) in block group 276 for inode table: Could not allocate block in ext2 filesystem
Restarting e2fsck from the beginning...
fsck.ext2: Group descriptors look bad... trying backup blocks...
Group descriptor 256 checksum is invalid.  Fix? yes

Group descriptor 257 checksum is invalid.  Fix? yes

Group descriptor 258 checksum is invalid.  Fix? yes

Group descriptor 259 checksum is invalid.  Fix? yes

Group descriptor 260 checksum is invalid.  Fix? yes

Group descriptor 261 checksum is invalid.  Fix? yes

Group descriptor 262 checksum is invalid.  Fix? yes

Group descriptor 263 checksum is invalid.  Fix? yes

Group descriptor 264 checksum is invalid.  Fix? yes

Group descriptor 265 checksum is invalid.  Fix? yes

Group descriptor 266 checksum is invalid.  Fix? yes

Group descriptor 267 checksum is invalid.  Fix? yes

Group descriptor 268 checksum is invalid.  Fix? yes

Group descriptor 269 checksum is invalid.  Fix? yes

Group descriptor 270 checksum is invalid.  Fix? yes

Group descriptor 271 checksum is invalid.  Fix? yes

Group descriptor 272 checksum is invalid.  Fix? yes

Group descriptor 273 checksum is invalid.  Fix? yes

Group descriptor 274 checksum is invalid.  Fix? yes

Group descriptor 275 checksum is invalid.  Fix? yes

Group descriptor 276 checksum is invalid.  Fix? yes

Group descriptor 277 checksum is invalid.  Fix? yes

Group descriptor 278 checksum is invalid.  Fix? yes

Group descriptor 279 checksum is invalid.  Fix? yes

Group descriptor 280 checksum is invalid.  Fix? yes

Group descriptor 281 checksum is invalid.  Fix? yes

Group descriptor 282 checksum is invalid.  Fix? yes

Group descriptor 283 checksum is invalid.  Fix? yes

Group descriptor 284 checksum is invalid.  Fix? yes

Group descriptor 285 checksum is invalid.  Fix? yes

Group descriptor 286 checksum is invalid.  Fix? yes

Group descriptor 287 checksum is invalid.  Fix? yes

Group descriptor 288 checksum is invalid.  Fix? yes

Group descriptor 289 checksum is invalid.  Fix? yes

Group descriptor 290 checksum is invalid.  Fix? yes

Group descriptor 291 checksum is invalid.  Fix? yes

Group descriptor 292 checksum is invalid.  Fix? yes

Group descriptor 293 checksum is invalid.  Fix? yes

Group descriptor 294 checksum is invalid.  Fix? yes

Group descriptor 295 checksum is invalid.  Fix? yes

Group descriptor 296 checksum is invalid.  Fix? yes

Group descriptor 297 checksum is invalid.  Fix? yes

Group descriptor 298 checksum is invalid.  Fix? yes

Group descriptor 299 checksum is invalid.  Fix? yes

Group descriptor 300 checksum is invalid.  Fix? yes

Group descriptor 301 checksum is invalid.  Fix? yes

Group descriptor 302 checksum is invalid.  Fix? yes

Group descriptor 303 checksum is invalid.  Fix? yes

Group descriptor 304 checksum is invalid.  Fix? yes

Group descriptor 305 checksum is invalid.  Fix? yes

Group descriptor 306 checksum is invalid.  Fix? yes

Group descriptor 307 checksum is invalid.  Fix? yes

Group descriptor 308 checksum is invalid.  Fix? yes

Group descriptor 309 checksum is invalid.  Fix? yes

Group descriptor 310 checksum is invalid.  Fix? yes

Group descriptor 311 checksum is invalid.  Fix? yes

Group descriptor 312 checksum is invalid.  Fix? yes

Group descriptor 313 checksum is invalid.  Fix? yes

Group descriptor 314 checksum is invalid.  Fix? yes

Group descriptor 315 checksum is invalid.  Fix? yes

Group descriptor 316 checksum is invalid.  Fix? yes

Group descriptor 317 checksum is invalid.  Fix? yes

Group descriptor 318 checksum is invalid.  Fix? yes

Group descriptor 319 checksum is invalid.  Fix? yes

Group descriptor 320 checksum is invalid.  Fix? yes

Group descriptor 321 checksum is invalid.  Fix? yes

Group descriptor 322 checksum is invalid.  Fix? yes

Group descriptor 323 checksum is invalid.  Fix? yes

Group descriptor 324 checksum is invalid.  Fix? yes

Group descriptor 325 checksum is invalid.  Fix? yes

Group descriptor 326 checksum is invalid.  Fix? yes

Group descriptor 327 checksum is invalid.  Fix? yes

Group descriptor 328 checksum is invalid.  Fix? yes

Group descriptor 329 checksum is invalid.  Fix? yes

Group descriptor 330 checksum is invalid.  Fix? yes

Group descriptor 331 checksum is invalid.  Fix? yes

Group descriptor 332 checksum is invalid.  Fix? yes

Group descriptor 333 checksum is invalid.  Fix? yes

Group descriptor 334 checksum is invalid.  Fix? yes

Group descriptor 335 checksum is invalid.  Fix? yes

Group descriptor 336 checksum is invalid.  Fix? yes

Group descriptor 337 checksum is invalid.  Fix? yes

Group descriptor 338 checksum is invalid.  Fix? yes

Group descriptor 339 checksum is invalid.  Fix? yes

Group descriptor 340 checksum is invalid.  Fix? yes

Group descriptor 341 checksum is invalid.  Fix? yes

Group descriptor 342 checksum is invalid.  Fix? yes

Group descriptor 343 checksum is invalid.  Fix? yes

Group descriptor 344 checksum is invalid.  Fix? yes

Group descriptor 345 checksum is invalid.  Fix? yes

Group descriptor 346 checksum is invalid.  Fix? yes

Group descriptor 347 checksum is invalid.  Fix? yes

Group descriptor 348 checksum is invalid.  Fix? yes

Group descriptor 349 checksum is invalid.  Fix? yes

Group descriptor 350 checksum is invalid.  Fix? yes

Group descriptor 351 checksum is invalid.  Fix? yes

Group descriptor 352 checksum is invalid.  Fix? yes

Group descriptor 353 checksum is invalid.  Fix? yes

Group descriptor 354 checksum is invalid.  Fix? yes

Group descriptor 355 checksum is invalid.  Fix? yes

Group descriptor 356 checksum is invalid.  Fix? yes

Group descriptor 357 checksum is invalid.  Fix? yes

Group descriptor 358 checksum is invalid.  Fix? yes

Group descriptor 359 checksum is invalid.  Fix? yes

Group descriptor 360 checksum is invalid.  Fix? yes

Group descriptor 361 checksum is invalid.  Fix? yes

Group descriptor 362 checksum is invalid.  Fix? yes

Group descriptor 363 checksum is invalid.  Fix? yes

Group descriptor 364 checksum is invalid.  Fix? yes

Group descriptor 365 checksum is invalid.  Fix? yes

Group descriptor 366 checksum is invalid.  Fix? yes

Group descriptor 367 checksum is invalid.  Fix? yes

Group descriptor 368 checksum is invalid.  Fix? yes

Group descriptor 369 checksum is invalid.  Fix? yes

Group descriptor 370 checksum is invalid.  Fix? yes

Group descriptor 371 checksum is invalid.  Fix? yes

Group descriptor 372 checksum is invalid.  Fix? yes

Group descriptor 373 checksum is invalid.  Fix? yes

Group descriptor 374 checksum is invalid.  Fix? yes

Group descriptor 375 checksum is invalid.  Fix? yes

Group descriptor 376 checksum is invalid.  Fix? yes

Group descriptor 377 checksum is invalid.  Fix? yes

Group descriptor 378 checksum is invalid.  Fix? yes

Group descriptor 379 checksum is invalid.  Fix? yes

Group descriptor 380 checksum is invalid.  Fix? yes

Group descriptor 381 checksum is invalid.  Fix? yes

Group descriptor 382 checksum is invalid.  Fix? yes

Group descriptor 383 checksum is invalid.  Fix? yes

/dev/foo contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes

Error allocating 205 contiguous block(s) in block group 276 for inode table: Could not allocate block in ext2 filesystem
Restarting e2fsck from the beginning...
fsck.ext2: Group descriptors look bad... trying backup blocks...
Group descriptor 256 checksum is invalid.  Fix? yes

Group descriptor 257 checksum is invalid.  Fix? yes

Group descriptor 258 checksum is invalid.  Fix? yes

Group descriptor 259 checksum is invalid.  Fix? yes

Group descriptor 260 checksum is invalid.  Fix? yes

Group descriptor 261 checksum is invalid.  Fix? yes

Group descriptor 262 checksum is invalid.  Fix? yes

Group descriptor 263 checksum is invalid.  Fix? yes

Group descriptor 264 checksum is invalid.  Fix? yes

Group descriptor 265 checksum is invalid.  Fix? yes

Group descriptor 266 checksum is invalid.  Fix? yes

Group descriptor 267 checksum is invalid.  Fix? yes

Group descriptor 268 checksum is invalid.  Fix? yes

Group descriptor 269 checksum is invalid.  Fix? yes

Group descriptor 270 checksum is invalid.  Fix? yes

Group descriptor 271 checksum is invalid.  Fix? yes

Group descriptor 272 checksum is invalid.  Fix? yes

Group descriptor 273 checksum is invalid.  Fix? yes

Group descriptor 274 checksum is invalid.  Fix? yes

Group descriptor 275 checksum is invalid.  Fix? yes

Group descriptor 276 checksum is invalid.  Fix? yes

Group descriptor 277 checksum is invalid.  Fix? yes

Group descriptor 278 checksum is invalid.  Fix? yes

Group descriptor 279 checksum is invalid.  Fix? yes

Group descriptor 280 checksum is invalid.  Fix? yes

Group descriptor 281 checksum is invalid.  Fix? yes

Group descriptor 282 checksum is invalid.  Fix? yes

Group descriptor 283 checksum is invalid.  Fix? yes

Group descriptor 284 checksum is invalid.  Fix? yes

Group descriptor 285 checksum is invalid.  Fix? yes

Group descriptor 286 checksum is invalid.  Fix? yes

Group descriptor 287 checksum is invalid.  Fix? yes

Group descriptor 288 checksum is invalid.  Fix? yes

Group descriptor 289 checksum is invalid.  Fix? yes

Group descriptor 290 checksum is invalid.  Fix? yes

Group descriptor 291 checksum is invalid.  Fix? yes

Group descriptor 292 checksum is invalid.  Fix? yes

Group descriptor 293 checksum is invalid.  Fix? yes

Group descriptor 294 checksum is invalid.  Fix? yes

Group descriptor 295 checksum is invalid.  Fix? yes

Group descriptor 296 checksum is invalid.  Fix? yes

Group descriptor 297 checksum is invalid.  Fix? yes

Group descriptor 298 checksum is invalid.  Fix? yes

Group descriptor 299 checksum is invalid.  Fix? yes

Group descriptor 300 checksum is invalid.  Fix? yes

Group descriptor 301 checksum is invalid.  Fix? yes

Group descriptor 302 checksum is invalid.  Fix? yes

Group descriptor 303 checksum is invalid.  Fix? yes

Group descriptor 304 checksum is invalid.  Fix? yes

Group descriptor 305 checksum is invalid.  Fix? yes

Group descriptor 306 checksum is invalid.  Fix? yes

Group descriptor 307 checksum is invalid.  Fix? yes

Group descriptor 308 checksum is invalid.  Fix? yes

Group descriptor 309 checksum is invalid.  Fix? yes

Group descriptor 310 checksum is invalid.  Fix? yes

Group descriptor 311 checksum is invalid.  Fix? yes

Group descriptor 312 checksum is invalid.  Fix? yes

Group descriptor 313 checksum is invalid.  Fix? yes

Group descriptor 314 checksum is invalid.  Fix? yes

Group descriptor 315 checksum is invalid.  Fix? yes

Group descriptor 316 checksum is invalid.  Fix? yes

Group descriptor 317 checksum is invalid.  Fix? yes

Group descriptor 318 checksum is invalid.  Fix? yes

Group descriptor 319 checksum is invalid.  Fix? yes

Group descriptor 320 checksum is invalid.  Fix? yes

Group descriptor 321 checksum is invalid.  Fix? yes

Group descriptor 322 checksum is invalid.  Fix? yes

Group descriptor 323 checksum is invalid.  Fix? yes

Group descriptor 324 checksum is invalid.  Fix? yes

Group descriptor 325 checksum is invalid.  Fix? yes

Group descriptor 326 checksum is invalid.  Fix? yes

Group descriptor 327 checksum is invalid.  Fix? yes

Group descriptor 328 checksum is invalid.  Fix? yes

Group descriptor 329 checksum is invalid.  Fix? yes

Group descriptor 330 checksum is invalid.  Fix? yes

Group descriptor 331 checksum is invalid.  Fix? yes

Group descriptor 332 checksum is invalid.  Fix? yes

Group descriptor 333 checksum is invalid.  Fix? yes

Group descriptor 334 checksum is invalid.  Fix? yes

Group descriptor 335 checksum is invalid.  Fix? yes

Group descriptor 336 checksum is invalid.  Fix? yes

Group descriptor 337 checksum is invalid.  Fix? yes

Group descriptor 338 checksum is invalid.  Fix? yes

Group descriptor 339 checksum is invalid.  Fix? yes

Group descriptor 340 checksum is invalid.  Fix? yes

Group descriptor 341 checksum is invalid.  Fix? yes

Group descriptor 342 checksum is invalid.  Fix? yes

Group descriptor 343 checksum is invalid.  Fix? yes

Group descriptor 344 checksum is invalid.  Fix? yes

Group descriptor 345 checksum is invalid.  Fix? yes

Group descriptor 346 checksum is invalid.  Fix? yes

Group descriptor 347 checksum is invalid.  Fix? yes

Group descriptor 348 checksum is invalid.  Fix? yes

Group descriptor 349 checksum is invalid.  Fix? yes

Group descriptor 350 checksum is invalid.  Fix? yes

Group descriptor 351 checksum is invalid.  Fix? yes

Group descriptor 352 checksum is invalid.  Fix? yes

Group descriptor 353 checksum is invalid.  Fix? yes

Group descriptor 354 checksum is invalid.  Fix? yes

Group descriptor 355 checksum is invalid.  Fix? yes

Group descriptor 356 checksum is invalid.  Fix? yes

Group descriptor 357 checksum is invalid.  Fix? yes

Group descriptor 358 checksum is invalid.  Fix? yes

Group descriptor 359 checksum is invalid.  Fix? yes

Group descriptor 360 checksum is invalid.  Fix? yes

Group descriptor 361 checksum is invalid.  Fix? yes

Group descriptor 362 checksum is invalid.  Fix? yes

Group descriptor 363 checksum is invalid.  Fix? yes

Group descriptor 364 checksum is invalid.  Fix? yes

Group descriptor 365 checksum is invalid.  Fix? yes

Group descriptor 366 checksum is invalid.  Fix? yes

Group descriptor 367 checksum is invalid.  Fix? yes

Group descriptor 368 checksum is invalid.  Fix? yes

Group descriptor 369 checksum is invalid.  Fix? yes

Group descriptor 370 checksum is invalid.  Fix? yes

Group descriptor 371 checksum is invalid.  Fix? yes

Group descriptor 372 checksum is invalid.  Fix? yes

Group descriptor 373 checksum is invalid.  Fix? yes

Group descriptor 374 checksum is invalid.  Fix? yes

Group descriptor 375 checksum is invalid.  Fix? yes

Group descriptor 376 checksum is invalid.  Fix? yes

Group descriptor 377 checksum is invalid.  Fix? yes

Group descriptor 378 checksum is invalid.  Fix? yes

Group descriptor 379 checksum is invalid.  Fix? yes

Group descriptor 380 checksum is invalid.  Fix? yes

Group descriptor 381 checksum is invalid.  Fix? yes

Group descriptor 382 checksum is invalid.  Fix? yes

Group descriptor 383 checksum is invalid.  Fix? yes

/dev/foo contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
^C/dev/foo: e2fsck canceled.

/dev/foo: ***** FILE SYSTEM WAS MODIFIED *****
fsck.ext2: Inode bitmap not loaded while setting block group checksum info


--=-fAX7j3M1Ym34X+/P+XIh--

